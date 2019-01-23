//
//  WebSocketEventMessageService.swift
//  Baby Monitor
//

import RxSwift

protocol WebSocketEventMessageServiceProtocol {
    var cryingEventObservable: Observable<Void> { get }
    func start()
    func sendMessage(_ message: String)
}

final class WebSocketEventMessageService: WebSocketEventMessageServiceProtocol {

    lazy var cryingEventObservable: Observable<Void> = cryingEventPublisher.asObservable()

    private let cryingEventsRepository: CryingEventsRepositoryProtocol
    private var eventMessageConductor: WebSocketConductorProtocol?
    private let cryingEventPublisher = PublishSubject<Void>()
    private let eventMessagePublisher = PublishSubject<String>()

    init(cryingEventsRepository: CryingEventsRepositoryProtocol, eventMessageConductorFactory: (Observable<String>, AnyObserver<EventMessage>) -> WebSocketConductorProtocol) {
        self.cryingEventsRepository = cryingEventsRepository
        setupEventMessageConductor(with: eventMessageConductorFactory)
    }

    private func setupEventMessageConductor(with factory: (Observable<String>, AnyObserver<EventMessage>) -> WebSocketConductorProtocol) {
        eventMessageConductor = factory(eventMessagePublisher, eventMessageHandler())
    }

    private func eventMessageHandler() -> AnyObserver<EventMessage> {
        return AnyObserver<EventMessage>(eventHandler: { [weak self] event in
            guard let event = event.element,
                let babyEvent = BabyMonitorEvent(rawValue: event.action) else {
                    return
            }
            switch babyEvent {
            case .crying:
                self?.cryingEventsRepository.save(cryingEvent: CryingEvent(fileName: event.value))
                self?.cryingEventPublisher.onNext(())
                let eventMessage = EventMessage.initWithMessageReceived()
                self?.eventMessagePublisher.onNext(eventMessage.toStringMessage())
            case .cryingEventMessageReceived, .pushNotificationsKey:
                break
            }
        })
    }

    func start() {
        eventMessageConductor?.open()
    }

    func sendMessage(_ message: String) {
        eventMessagePublisher.onNext(message)
    }
}
