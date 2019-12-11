//
//  ClientSetupOnboardingViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import RxCocoa

enum DeviceSearchError: Error {
    case timeout
}

enum DeviceSearchResult: Equatable {
    case success
    case failure(DeviceSearchError)
}

final class ClientSetupOnboardingViewModel {

    private enum PairingError: Error {
        case timeout
    }

    let bag = DisposeBag()
    var cancelTap: Observable<Void>?

    // MARK: - Coordinator callback
    var didFinishDeviceSearch: ((DeviceSearchResult) -> Void)?

    let title: String = Localizable.Onboarding.connecting

    var description: String {
        switch state.value {
        case .noneFound: return Localizable.Onboarding.Pairing.searchingForSecondDevice
        case .someFound, .timeoutReached: return "Some found"
        }
    }
    
    var buttonTitle: String {
        switch state.value {
        case .noneFound: return Localizable.General.cancel
        case .someFound, .timeoutReached: return "Refresh the list"
        }
    }
    private(set) var state = BehaviorRelay<PairingSearchState>(value: .noneFound)
    private(set) var availableDevicesPublisher = BehaviorRelay<[NetServiceDescriptor]>(value: [])
    private var searchCancelTimer: Timer?
    private let netServiceClient: NetServiceClientProtocol
    private let urlConfiguration: URLConfiguration
    private let activityLogEventsRepository: ActivityLogEventsRepositoryProtocol
    private let disposeBag = DisposeBag()
    private let webSocketEventMessageService: WebSocketEventMessageServiceProtocol
    private let errorLogger: ServerErrorLogger

    init(netServiceClient: NetServiceClientProtocol,
         urlConfiguration: URLConfiguration,
         activityLogEventsRepository: ActivityLogEventsRepositoryProtocol,
         webSocketEventMessageService: WebSocketEventMessageServiceProtocol,
         serverErrorLogger: ServerErrorLogger) {
        self.netServiceClient = netServiceClient
        self.urlConfiguration = urlConfiguration
        self.activityLogEventsRepository = activityLogEventsRepository
        self.webSocketEventMessageService = webSocketEventMessageService
        self.errorLogger = serverErrorLogger
        setupRx()
    }

    func attachInput(cancelButtonTap: Observable<Void>) {
        cancelTap = cancelButtonTap
        cancelTap?.subscribe(onNext: { [weak self] in
            self?.searchCancelTimer?.invalidate()
            self?.state.accept(.noneFound)
            self?.netServiceClient.isEnabled.value = false
            self?.startDiscovering()
        })
        .disposed(by: bag)
    }

    func pair(with device: NetServiceDescriptor) {
        guard let serverUrl = URL.with(ip: device.ip, port: device.port, prefix: Constants.protocolPrefix) else {
                return
        }
        searchCancelTimer?.invalidate()
        urlConfiguration.url = serverUrl
        webSocketEventMessageService.start()
        saveEmptyStateIfNeeded()
        didFinishDeviceSearch?(.success)
    }
    
    func startDiscovering(withTimeout timeout: TimeInterval = Constants.pairingDeviceSearchTimeLimit) {
        searchCancelTimer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false, block: { [weak self] _ in
            guard let self = self else { return }
            if self.availableDevicesPublisher.value.isEmpty {
                self.didFinishDeviceSearch?(.failure(.timeout))
                self.errorLogger.log(error: PairingError.timeout)
                self.netServiceClient.isEnabled.value = false
                self.searchCancelTimer = nil
            } else {
                self.state.accept(.timeoutReached)
                self.netServiceClient.isEnabled.value = false
                self.searchCancelTimer = nil
            }
        })
        netServiceClient.isEnabled.value = true
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
    
    private func saveEmptyStateIfNeeded() {
        let allActivityLogEvents = activityLogEventsRepository.fetchAllActivityLogEvents()
        guard allActivityLogEvents.first(where: { $0.mode == .emptyState }) == nil else {
            return
        }
        let emptyStateLogEvent = ActivityLogEvent(mode: .emptyState)
        activityLogEventsRepository.save(activityLogEvent: emptyStateLogEvent, completion: { _ in })
    }
}
