//
//  WebSocketEventMessageServiceMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import RxSwift

final class WebSocketEventMessageServiceMock: WebSocketEventMessageServiceProtocol {

    lazy var connectionStatusObservable: Observable<WebSocketConnectionStatus> = connectionStatusPublisher.asObservable()
    lazy var remoteResetObservable: Observable<Void> = remoteResetPublisher.asObservable()
    lazy var remotePairingCodeResponseObservable: Observable<Bool> = remotePairingCodeResponsePublisher.asObservable()
    lazy var remoteStreamConnectingErrorObservable: Observable<String> = remoteStreamConnectingErrorPublisher.asObservable()
    let remotePairingCodeResponsePublisher = PublishSubject<Bool>()
    let connectionStatusPublisher = PublishSubject<WebSocketConnectionStatus>()
    var shouldNotConfirmMessage = false
    private let remoteResetPublisher = PublishSubject<Void>()
    private let remoteStreamConnectingErrorPublisher = PublishSubject<String>()
    private(set) var isOpen = false
    private(set) var messages = [String]()

    func start() {
        isOpen = true
    }

    func close() {
        isOpen = false
    }

    func sendMessage(_ message: String) {
        messages.append(message)
    }

    func sendMessage(_ message: EventMessage, completion: @escaping (Result<()>) -> Void) {
        if message.confirmationId != nil && !shouldNotConfirmMessage {
            completion(.success(()))
        } else {
            completion(.failure(nil))
        }
        messages.append(message.toStringMessage())
    }
}
