//
//  WebSocketEventMessageService.swift
//  Baby Monitor
//

import RxSwift

protocol WebSocketEventMessageServiceProtocol: class {
    var remoteResetObservable: Observable<Void> { get }
    var remotePairingCodeResponseObservable: Observable<Bool> { get }
    var remoteStreamConnectingErrorObservable: Observable<String> { get }
    func start()
    func close()
    func sendMessage(_ message: String)
    func sendMessage(_ message: EventMessage, completion: @escaping (Result<()>) -> Void)
}

final class WebSocketEventMessageService: WebSocketEventMessageServiceProtocol {

    private enum EventMessageError: Error {
        case idNotConfirmed
    }
    private(set) lazy var remoteResetObservable = remoteResetPublisher.asObservable()
    private(set) lazy var remotePairingCodeResponseObservable = remotePairingCodeResponsePublisher.asObservable()
    private(set) lazy var remoteStreamConnectingErrorObservable = remoteStreamConnectingErrorPublisher.asObservable()

    private var eventMessageConductor: WebSocketConductorProtocol?
    private let eventMessagePublisher = PublishSubject<String>()
    private let remoteResetPublisher = PublishSubject<Void>()
    private let remotePairingCodeResponsePublisher = PublishSubject<Bool>()
    private let remoteStreamConnectingErrorPublisher = PublishSubject<String>()
    private let remoteConfimationIdPublisher = PublishSubject<Int>()
    private let disposeBag = DisposeBag()

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
            if let webRtcSdpErrorMessage = event.webRtcSdpErrorMessage {
                self?.remoteStreamConnectingErrorPublisher.onNext(webRtcSdpErrorMessage)
            }
            if let confirmationID = event.confirmationId {
                self?.remoteConfimationIdPublisher.onNext(confirmationID)
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

    func sendMessage(_ message: EventMessage, completion: @escaping (Result<()>) -> Void) {
        if let confimationID = message.confirmationId {
            sendMessage(message.toStringMessage())
            remoteConfimationIdPublisher
                .take(1)
                .timeout(Constants.webSocketConfimationIDTimeLimit, scheduler: MainScheduler.instance)
                .subscribe(onNext: { eventConfimationId in
                    if confimationID == eventConfimationId {
                        completion(.success(()))
                    } else {
                        completion(.failure(EventMessageError.idNotConfirmed))
                    }
                }, onError: { error in
                    completion(.failure(error))
                }).disposed(by: disposeBag)

        } else {
            sendMessage(message.toStringMessage())
            completion(.success(()))
        }
    }
}
