//
//  WebSocketMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import RxSwift

final class WebSocketMock: WebSocketProtocol {
    
    lazy var disconnectionObservable = disconnectionPublisher.asObservable()
    private var disconnectionPublisher = PublishSubject<Void>()
    var isOpen = false {
        didSet {
            if !isOpen {
                disconnectionPublisher.onNext(())
            }
        }
    }
    
    var receivedMessage: Observable<String> {
        return receivedMessagePublisher
    }
    let receivedMessagePublisher = PublishSubject<String>()
    
    private(set) var sentMessages = [Any]()
    
    func send(message: Any) {
        sentMessages.append(message)
    }
    
    func open() {
        isOpen = true
    }
    
    func close() {
        isOpen = false
    }
}
