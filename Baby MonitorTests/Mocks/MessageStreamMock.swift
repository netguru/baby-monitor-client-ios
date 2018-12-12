//
//  MessageStreamMock.swift
//  Baby MonitorTests
//

import RxSwift
@testable import BabyMonitor

final class MessageStreamMock: MessageStreamProtocol {
    
    var receivedMessage: Observable<String> {
        return receivedMessagePublisher
    }
    let receivedMessagePublisher = PublishSubject<String>()
}
