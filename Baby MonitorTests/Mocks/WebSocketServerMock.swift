//
//  WebSocketServerMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import RxSwift

final class WebSocketServerMock: WebSocketServerProtocol {
    
    var receivedMessage: Observable<String> {
        return receivedMessagePublisher
    }
    let receivedMessagePublisher = PublishSubject<String>()
   
    var connectedSocket: Observable<WebSocketProtocol> {
        return connectedSocketPublisher
    }
    let connectedSocketPublisher = PublishSubject<WebSocketProtocol>()
    
    var disconnectedSocket: Observable<WebSocketProtocol> {
        return disconnectedSocketPublisher.asObservable()
    }
    let disconnectedSocketPublisher = PublishSubject<WebSocketProtocol>()
    
    private(set) var isStarted = false
    
    func start() {
        isStarted = true
    }
    
    func stop() {
        isStarted = false
    }
}
