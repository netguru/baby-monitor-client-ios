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
    var selectFirstAction: (() -> Void)?
    var selectSecondAction: (() -> Void)?
    
    // MARK: - Coordinator callback
    var didFinishDeviceSearch: ((DeviceSearchResult) -> Void)?
    
    let title = Localizable.Onboarding.connecting
    let description = Localizable.Onboarding.Pairing.searchingForSecondDevice
    let image = #imageLiteral(resourceName: "onboarding-oval")
    
    private var searchCancelTimer: Timer?
    private let netServiceClient: NetServiceClientProtocol
    private let urlConfiguration: URLConfiguration
    private let activityLogEventsRepository: ActivityLogEventsRepositoryProtocol
    private let cacheService: CacheServiceProtocol
    private let disposeBag = DisposeBag()
    private let webSocketEventMessageService: WebSocketEventMessageServiceProtocol

    init(netServiceClient: NetServiceClientProtocol, urlConfiguration: URLConfiguration, activityLogEventsRepository: ActivityLogEventsRepositoryProtocol, cacheService: CacheServiceProtocol, webSocketEventMessageService: WebSocketEventMessageServiceProtocol) {
        self.netServiceClient = netServiceClient
        self.urlConfiguration = urlConfiguration
        self.activityLogEventsRepository = activityLogEventsRepository
        self.cacheService = cacheService
        self.webSocketEventMessageService = webSocketEventMessageService
        setupRx()
    }
    
    func startDiscovering(withTimeout timeout: TimeInterval = 5.0) {
        searchCancelTimer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false, block: { [weak self] _ in
            self?.didFinishDeviceSearch?(.failure(.timeout))
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
                let cryingEventMessage = EventMessage.initWithPushNotificationsKey(key: self.cacheService.selfPushNotificationsToken!)
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
        activityLogEventsRepository.save(activityLogEvent: emptyStateLogEvent)
    }
}
