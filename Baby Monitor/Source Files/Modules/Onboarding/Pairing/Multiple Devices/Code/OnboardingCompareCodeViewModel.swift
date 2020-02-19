//
//  OnboardingCompareCodeViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import RxCocoa

final class OnboardingCompareCodeViewModel: BaseViewModel {

    let bag = DisposeBag()
    let title: String = Localizable.Onboarding.connecting
    let description = Localizable.Onboarding.Connecting.compareCodeDescription
    let codeText: String

    private let webSocketEventMessageService: WebSocketEventMessageServiceProtocol
    private let urlConfiguration: URLConfiguration
    private let serverURL: URL
    private let activityLogEventsRepository: ActivityLogEventsRepositoryProtocol

    init(webSocketEventMessageService: WebSocketEventMessageServiceProtocol,
         urlConfiguration: URLConfiguration,
         serverURL: URL,
         activityLogEventsRepository: ActivityLogEventsRepositoryProtocol,
         randomizer: RandomGenerator,
         analytics: AnalyticsManager) {
        self.webSocketEventMessageService = webSocketEventMessageService
        self.urlConfiguration = urlConfiguration
        self.serverURL = serverURL
        self.activityLogEventsRepository = activityLogEventsRepository
        self.codeText = String(randomizer.generateRandomCode())
        super.init(analytics: analytics)
        setupBindings()
    }

    func sendCode() {
        urlConfiguration.url = serverURL
        webSocketEventMessageService.start()
        let message = EventMessage(pairingCode: codeText)
        webSocketEventMessageService.sendMessage(message.toStringMessage())
    }

    func cancelPairingAttempt() {
        let message = EventMessage(pairingCode: "")
        webSocketEventMessageService.sendMessage(message.toStringMessage())
        webSocketEventMessageService.close()
    }

    private func setupBindings() {
        webSocketEventMessageService.remotePairingCodeResponseObservable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isSuccessful in
                guard let self = self else { return }
                if isSuccessful {
                    self.saveEmptyStateIfNeeded()
                } else {
                    self.webSocketEventMessageService.close()
                }
            }).disposed(by: bag)
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
