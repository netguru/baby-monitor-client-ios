//
//  OnboardingClientSetupViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import RxCocoa

enum DeviceSearchError: Error {
    case timeout
}

enum DeviceSearchResult: Equatable {
    case success(URL)
    case failure(DeviceSearchError)
}

final class OnboardingClientSetupViewModel {

    private enum PairingError: Error {
        case timeout
    }

    let bag = DisposeBag()
    var cancelTap: Observable<Void>?

    // MARK: - Coordinator callback
    var didFinishDeviceSearch: ((DeviceSearchResult) -> Void)?

    let title: String = Localizable.Onboarding.connecting
    let description = Localizable.Onboarding.Connecting.availableDevices
    let buttonTitle = Localizable.Onboarding.Connecting.refreshButtonTitle

    let state = BehaviorRelay<PairingSearchState>(value: .noneFound)
    let availableDevicesPublisher = BehaviorRelay<[NetServiceDescriptor]>(value: [])
    let analyticsManager: AnalyticsManager

    private var searchCancelTimer: Timer?
    private let netServiceClient: NetServiceClientProtocol
    private let disposeBag = DisposeBag()
    private let webSocketEventMessageService: WebSocketEventMessageServiceProtocol
    private let errorLogger: ServerErrorLogger

    init(netServiceClient: NetServiceClientProtocol,
         urlConfiguration: URLConfiguration,
         activityLogEventsRepository: ActivityLogEventsRepositoryProtocol,
         webSocketEventMessageService: WebSocketEventMessageServiceProtocol,
         serverErrorLogger: ServerErrorLogger,
         analyticsManager: AnalyticsManager) {
        self.netServiceClient = netServiceClient
        self.webSocketEventMessageService = webSocketEventMessageService
        self.errorLogger = serverErrorLogger
        self.analyticsManager = analyticsManager
        setupRx()
    }

    func attachInput(refreshButtonTap: Observable<Void>) {
        refreshButtonTap.subscribe(onNext: { [weak self] in
            self?.stopDiscovering()
            self?.startDiscovering()
        })
        .disposed(by: bag)
    }

    func pair(with device: NetServiceDescriptor) {
        guard let serverUrl = URL.with(ip: device.ip, port: device.port, prefix: Constants.protocolPrefix) else {
            return
        }
        searchCancelTimer?.invalidate()
        didFinishDeviceSearch?(.success(serverUrl))
    }
    
    func startDiscovering(withTimeout timeout: TimeInterval = Constants.pairingDeviceSearchTimeLimit) {
        searchCancelTimer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false, block: { [weak self] _ in
            guard let self = self else { return }
            if self.availableDevicesPublisher.value.isEmpty {
                self.didFinishDeviceSearch?(.failure(.timeout))
                self.errorLogger.log(error: PairingError.timeout)
            } else {
                self.state.accept(.timeoutReached)
            }
            self.netServiceClient.isEnabled.value = false
            self.searchCancelTimer = nil
        })
        netServiceClient.isEnabled.value = true
    }

    func stopDiscovering() {
        netServiceClient.isEnabled.value = false
        searchCancelTimer?.invalidate()
        availableDevicesPublisher.accept([])
        state.accept(.noneFound)
    }

    private func setupRx() {
        netServiceClient.services
            .subscribe(onNext: { [weak self] netServices in
                guard let self = self, self.state.value != .timeoutReached else {
                    return
                }
                let searchingState: PairingSearchState = netServices.isEmpty ? .noneFound : .someFound
                self.availableDevicesPublisher.accept(netServices)
                self.state.accept(searchingState)
            })
            .disposed(by: disposeBag)
    }
}
