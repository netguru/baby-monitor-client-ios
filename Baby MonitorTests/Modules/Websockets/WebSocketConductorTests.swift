//
//  WebSocketConductorTests.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import XCTest
import RxSwift
import RxTest

class WebSocketConductorTests: XCTestCase {

    func testShouldOpenWebsocketConnection() {
        // Given
        let words = ["test", "test1", "test2"]
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let webSocket = WebSocketMock()
        let messageEmitter = PublishSubject<String>()
        let messageHandler = AnyObserver<Bool>(observer)
        let decoder = AnyMessageDecoder<Bool>(MessageDecoderMock(words: Set(words)))
        let sut = WebSocketConductor(webSocket: webSocket, messageEmitter: messageEmitter, messageHandler: messageHandler, messageDecoders: [decoder])

        // When
        sut.open()

        // Then
        XCTAssertTrue(webSocket.isOpen)
    }

    func testShouldPropagateDecodedMessageToObserver() {
        // Given
        let words = ["test", "test1", "test2"]
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let webSocket = WebSocketMock()
        let messageEmitter = PublishSubject<String>()
        let messageHandler = AnyObserver<Bool>(observer)
        let decoder = AnyMessageDecoder<Bool>(MessageDecoderMock(words: Set(words)))
        let sut = WebSocketConductor(webSocket: webSocket, messageEmitter: messageEmitter, messageHandler: messageHandler, messageDecoders: [decoder])

        // When
        sut.open()
        webSocket.receivedMessagePublisher.onNext(words[0])

        // Then
        XCTAssertRecordedElements(observer.events, [true])
    }

    func testShouldSendEmittedMessage() {
        // Given
        let words = ["test", "test1", "test2"]
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let webSocket = WebSocketMock()
        let messageEmitter = PublishSubject<String>()
        let messageHandler = AnyObserver<Bool>(observer)
        let decoder = AnyMessageDecoder<Bool>(MessageDecoderMock(words: Set(words)))
        let sut = WebSocketConductor(webSocket: webSocket, messageEmitter: messageEmitter, messageHandler: messageHandler, messageDecoders: [decoder])

        // When
        sut.open()
        messageEmitter.onNext(words[0])

        // Then
        XCTAssertEqual([words[0]], webSocket.sentMessages as! [String])
    }
}
