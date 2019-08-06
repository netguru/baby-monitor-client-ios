//
//  WebSocketEventMessageService.swift
//  Baby Monitor
//

import RxSwift

protocol WebSocketEventMessageServiceProtocol {
    var remoteResetObservable: Observable<Void> { get }
    
    func start()
    func sendMessage(_ message: String)
}

final class WebSocketEventMessageService: WebSocketEventMessageServiceProtocol {

    private(set) lazy var remoteResetObservable = remoteResetPublisher.asObservable()
    
    private var eventMessageConductor: WebSocketConductorProtocol?
    private let eventMessagePublisher = PublishSubject<String>()
    private let remoteResetPublisher = PublishSubject<Void>()

    init(cryingEventsRepository: ActivityLogEventsRepositoryProtocol, eventMessageConductorFactory: (Observable<String>, AnyObserver<EventMessage>?) -> WebSocketConductorProtocol) {
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
            case .resetKey:
                DispatchQueue.main.async {
                    self?.remoteResetPublisher.onNext(())
                }
            case .pushNotificationsKey:
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
