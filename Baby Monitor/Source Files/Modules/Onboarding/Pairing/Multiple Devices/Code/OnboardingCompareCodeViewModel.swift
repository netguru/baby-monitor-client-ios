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

    init(webSocketEventMessageService: ClearableLazyItem<WebSocketEventMessageServiceProtocol>) {
        self.webSocketEventMessageService = webSocketEventMessageService
    }

    func sendCode() {
        let message = EventMessage(action: BabyMonitorEvent.pairingCodeKey.rawValue, value: codeText)
        webSocketEventMessageService.get().sendMessage(message.toStringMessage())
    }
}
