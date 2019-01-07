//
//  MessageStreamProtocolTests.swift
//  Baby MonitorTests
//

import XCTest
import RxSwift
import RxTest
@testable import BabyMonitor

class MessageStreamProtocolTests: XCTestCase {

    func testShouldDecodeMessageUsingDecoder() {
        // Given
        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool?.self)
        let sut = MessageStreamMock()
        let message = "test"
        let decoder = AnyMessageDecoder<Bool>(MessageDecoderMock(words: [message]))
        sut.decodedMessage(using: [decoder])
            .subscribe(observer)
            .disposed(by: bag)
        
        // When
        scheduler.start()
        sut.receivedMessagePublisher.onNext(message)
        
        // Then
        XCTAssertRecordedElements(observer.events, [true])
    }
    
    func testShouldDecodeMessageUsingDifferentDecoders() {
        // Given
        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool?.self)
        let sut = MessageStreamMock()
        let message = "test"
        let decoder = AnyMessageDecoder<Bool>(MessageDecoderMock(words: [message + message]))
        let validDecoder = AnyMessageDecoder<Bool>(MessageDecoderMock(words: [message]))
        sut.decodedMessage(using: [decoder, validDecoder])
            .subscribe(observer)
            .disposed(by: bag)
        
        // When
        scheduler.start()
        sut.receivedMessagePublisher.onNext(message)
        
        // Then
        XCTAssertRecordedElements(observer.events, [true])
    }
    
    func testShouldReturnNilIfDecodingFails() {
        // Given
        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool?.self)
        let sut = MessageStreamMock()
        let message = "test"
        let decoder = AnyMessageDecoder<Bool>(MessageDecoderMock(words: [message + message]))
        let validDecoder = AnyMessageDecoder<Bool>(MessageDecoderMock(words: [message + message + message]))
        sut.decodedMessage(using: [decoder, validDecoder])
            .subscribe(observer)
            .disposed(by: bag)
        
        // When
        scheduler.start()
        sut.receivedMessagePublisher.onNext(message)
        
        // Then
        XCTAssertRecordedElements(observer.events, [nil])
    }
}
