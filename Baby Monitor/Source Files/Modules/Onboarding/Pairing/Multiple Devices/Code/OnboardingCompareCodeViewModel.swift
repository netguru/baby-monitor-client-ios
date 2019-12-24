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

    private let webSocketEventMessageService: ClearableLazyItem<WebSocketEventMessageServiceProtocol>
    private let webSocket: ClearableLazyItem<WebSocketProtocol?>
    private let activityLogEventsRepository: ActivityLogEventsRepositoryProtocol

    init(webSocketEventMessageService: ClearableLazyItem<WebSocketEventMessageServiceProtocol>,
         webSocket: ClearableLazyItem<WebSocketProtocol?>,
         activityLogEventsRepository: ActivityLogEventsRepositoryProtocol) {
        self.webSocketEventMessageService = webSocketEventMessageService
        self.webSocket = webSocket
        self.activityLogEventsRepository = activityLogEventsRepository
        setupBindings()
    }

    func sendCode() {
        let message = EventMessage(action: BabyMonitorEvent.pairingCodeKey.rawValue, value: codeText)
        webSocketEventMessageService.get().sendMessage(message.toStringMessage())
    }

    private func setupBindings() {
        webSocketEventMessageService.get().remotePairingCodeResponseObservable
            .observeOn(MainScheduler.asyncInstance)
        .subscribe(onNext: { [weak self] isSuccessful in
            guard let self = self else { return }
            if isSuccessful {
               self.saveEmptyStateIfNeeded()
            } else {
               self.webSocket.get()?.close()
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
