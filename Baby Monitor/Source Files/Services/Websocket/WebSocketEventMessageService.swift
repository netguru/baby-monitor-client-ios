//
//  WebSocketEventMessageService.swift
//  Baby Monitor
//

import RxSwift

protocol WebSocketEventMessageServiceProtocol {
    func start()
    func sendMessage(_ message: String)
}

final class WebSocketEventMessageService: WebSocketEventMessageServiceProtocol {

    private var eventMessageConductor: WebSocketConductorProtocol?
    private let eventMessagePublisher = PublishSubject<String>()

    init(cryingEventsRepository: ActivityLogEventsRepositoryProtocol, eventMessageConductorFactory: (Observable<String>, AnyObserver<EventMessage>?) -> WebSocketConductorProtocol) {
        setupEventMessageConductor(with: eventMessageConductorFactory)
    }

    private func setupEventMessageConductor(with factory: (Observable<String>, AnyObserver<EventMessage>?) -> WebSocketConductorProtocol) {
        eventMessageConductor = factory(eventMessagePublisher, nil)
    }
    func start() {
        eventMessageConductor?.open()
    }

    func sendMessage(_ message: String) {
        eventMessagePublisher.onNext(message)
    }
}
