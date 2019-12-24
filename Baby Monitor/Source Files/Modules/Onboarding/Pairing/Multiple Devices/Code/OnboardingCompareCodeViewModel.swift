//
//  OnboardingCompareCodeViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import RxCocoa

final class OnboardingCompareCodeViewModel {

    let bag = DisposeBag()
    let title: String = Localizable.Onboarding.connecting
    let description = Localizable.Onboarding.Connecting.compareCodeDescription
    let codeText = Int.random(in: 1000...9999).toStringMessage()

    private let webSocketEventMessageService: WebSocketEventMessageServiceProtocol
    private let urlConfiguration: URLConfiguration
    private let serverURL: URL
    private let activityLogEventsRepository: ActivityLogEventsRepositoryProtocol

    init(webSocketEventMessageService: WebSocketEventMessageServiceProtocol,
         urlConfiguration: URLConfiguration,
         serverURL: URL,
         activityLogEventsRepository: ActivityLogEventsRepositoryProtocol) {
        self.webSocketEventMessageService = webSocketEventMessageService
        self.urlConfiguration = urlConfiguration
        self.serverURL = serverURL
        self.activityLogEventsRepository = activityLogEventsRepository
        setupBindings()
    }

    func sendCode() {
        urlConfiguration.url = serverURL
        webSocketEventMessageService.start()
        let message = EventMessage(action: BabyMonitorEvent.pairingCodeKey.rawValue, value: codeText)
        webSocketEventMessageService.sendMessage(message.toStringMessage())
    }

    func cancelPairingAttempt() {
        let message = EventMessage(action: BabyMonitorEvent.pairingCodeKey.rawValue, value: "")
        webSocketEventMessageService.sendMessage(message.toStringMessage())
        webSocketEventMessageService.close()
    }

    private func setupBindings() {
        webSocketEventMessageService.remotePairingCodeResponseObservable
            .observeOn(MainScheduler.asyncInstance)
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
