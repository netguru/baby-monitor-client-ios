//
//  MessageServerTests.swift
//  Baby MonitorTests
//

import XCTest
@testable import BabyMonitor
import RxSwift
import RxTest

class MessageServerTests: XCTestCase {

    func testShouldStartWebsocketServer() {
        // Given
        let server = WebSocketServerMock()
        let sut = MessageServer(server: server)
        
        // When
        sut.start()
        
        // Then
        XCTAssertTrue(server.isStarted)
    }
    
    func testShouldStopWebsocketServer() {
        // Given
        let server = WebSocketServerMock()
        let sut = MessageServer(server: server)
        
        // When
        sut.start()
        sut.stop()
        
        // Then
        XCTAssertFalse(server.isStarted)
    }
    
    func testShouldSendMessageIfSocketIsConnected() {
        // Given
        let socket = WebSocketMock()
        let server = WebSocketServerMock()
        let sut = MessageServer(server: server)
        let message = "test"
        
        // When
        sut.start()
        server.connectedSocketPublisher.onNext(socket)
        sut.send(message: message)
        
        // Then
        XCTAssertEqual([message], socket.sentMessages as! [String])
    }
    
    func testShouldNotSendMessageIfSocketIsDisconnected() {
        // Given
        let socket = WebSocketMock()
        let server = WebSocketServerMock()
        let sut = MessageServer(server: server)
        let message = "test"
        
        // When
        sut.start()
        server.connectedSocketPublisher.onNext(socket)
        server.disconnectedSocketPublisher.onNext(socket)
        sut.send(message: message)
        
        // Then
        XCTAssertTrue(socket.sentMessages.isEmpty)
    }
    
    func testShouldSendMessageIfSocketIsConnectedAfterDisconnect() {
        // Given
        let socket = WebSocketMock()
        let server = WebSocketServerMock()
        let sut = MessageServer(server: server)
        let message = "test"
        
        // When
        sut.start()
        server.connectedSocketPublisher.onNext(socket)
        server.disconnectedSocketPublisher.onNext(socket)
        server.connectedSocketPublisher.onNext(socket)
        sut.send(message: message)
        
        // Then
        XCTAssertEqual([message], socket.sentMessages as! [String])
    }
}
