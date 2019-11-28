//
//  MessageServerMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import RxSwift

final class MessageServerMock: MessageServerProtocol {

    private(set) var isStarted = false
    private(set) var sentMessages = [String]()
    let connectionStatusPublisher = PublishSubject<WebSocketConnectionStatus>()
    var connectionStatusObservable: Observable<WebSocketConnectionStatus> {
        return connectionStatusPublisher
    }
    
    var receivedMessage: Observable<String> {
        return receivedMessagePublisher
    }
    let receivedMessagePublisher = PublishSubject<String>()

    func send(message: String) {
        sentMessages.append(message)
    }

    func start() {
        isStarted = true
    }

    func stop() {
        isStarted = false
    }
}
