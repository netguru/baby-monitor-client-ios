//
//  ClientSetupOnboardingViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift

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
    var selectFirstAction: (() -> Void)?
    var selectSecondAction: (() -> Void)?
    var cancelTap: Observable<Void>?

    // MARK: - Coordinator callback
    var didFinishDeviceSearch: ((DeviceSearchResult) -> Void)?
    
    let title = Localizable.Onboarding.connecting
    let description = Localizable.Onboarding.Pairing.searchingForSecondDevice
    let image = #imageLiteral(resourceName: "onboarding-oval")
    
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
            self?.netServiceClient.isEnabled.value = false
        })
        .disposed(by: bag)
    }
    
    func startDiscovering(withTimeout timeout: TimeInterval = Constants.pairingDeviceSearchTimeLimit) {
        searchCancelTimer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false, block: { [weak self] _ in
            self?.didFinishDeviceSearch?(.failure(.timeout))
            self?.errorLogger.log(error: PairingError.timeout)
            self?.netServiceClient.isEnabled.value = false
            self?.searchCancelTimer = nil
        })
        netServiceClient.isEnabled.value = true
    }
    
    private func setupRx() {
        netServiceClient.service
            .filter { $0 != nil }
            .map { $0! }
            .take(1)
            .subscribe(onNext: { [weak self] ip, port in
                guard let serverUrl = URL.with(ip: ip, port: port, prefix: Constants.protocolPrefix),
                    let self = self else {
                        return
                }
                self.searchCancelTimer?.invalidate()
                self.urlConfiguration.url = serverUrl
                self.webSocketEventMessageService.start()
                let cryingEventMessage = EventMessage.initWithPushNotificationsKey(key: UserDefaults.selfPushNotificationsToken)
                self.webSocketEventMessageService.sendMessage(cryingEventMessage.toStringMessage())
                self.saveEmptyStateIfNeeded()
                self.didFinishDeviceSearch?(.success)
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
