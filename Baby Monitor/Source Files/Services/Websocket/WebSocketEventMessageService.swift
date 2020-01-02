//
//  WebSocketEventMessageService.swift
//  Baby Monitor
//

import RxSwift

protocol WebSocketEventMessageServiceProtocol: class {
    var remoteResetObservable: Observable<Void> { get }
    var remotePairingCodeResponseObservable: Observable<Bool> { get }

    func start()
    func close()
    func sendMessage(_ message: String)
}

final class WebSocketEventMessageService: WebSocketEventMessageServiceProtocol {

    private(set) lazy var remoteResetObservable = remoteResetPublisher.asObservable()
    private(set) lazy var remotePairingCodeResponseObservable = remotePairingCodeResponsePublisher.asObservable()

    private var eventMessageConductor: WebSocketConductorProtocol?
    private let eventMessagePublisher = PublishSubject<String>()
    private let remoteResetPublisher = PublishSubject<Void>()
    private let remotePairingCodeResponsePublisher = PublishSubject<Bool>()

    init(cryingEventsRepository: ActivityLogEventsRepositoryProtocol, eventMessageConductorFactory: (Observable<String>, AnyObserver<EventMessage>?) -> WebSocketConductorProtocol) {
        setupEventMessageConductor(with: eventMessageConductorFactory)
    }

    private func setupEventMessageConductor(with factory: (Observable<String>, AnyObserver<EventMessage>) -> WebSocketConductorProtocol) {
        eventMessageConductor = factory(eventMessagePublisher, eventMessageHandler())
    }
    
    private func eventMessageHandler() -> AnyObserver<EventMessage> {
        return AnyObserver<EventMessage>(eventHandler: { [weak self] event in
            guard let event = event.element else {
                    return
            }
            if case .reset = event.action {
                self?.remoteResetPublisher.onNext(())
            }
            if let isPairingApproved = event.pairingCodeResponse {
                self?.remotePairingCodeResponsePublisher.onNext(isPairingApproved)
            }
        })
    }
    
    func start() {
        eventMessageConductor?.open()
    }

    func close() {
        eventMessageConductor?.close()
    }

    func sendMessage(_ message: String) {
        eventMessagePublisher.onNext(message)
    }
}
