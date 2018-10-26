//
//  NetServiceConnectionCheckerTests.swift
//  Baby MonitorTests
//

import XCTest
import RxSwift
import RxTest
@testable import BabyMonitor

class NetServiceConnectionCheckerTests: XCTestCase {
    
    func testShouldUpdateStatusToConnectedIfDeviceIsFound() {
        // Given
        let exp = expectation(description: "Should update status")
        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(ConnectionStatus.self)
        let configuration = RTSPConfigurationMock()
        configuration.url = URL(string: "rtsp://ip:port")
        let clientMock = NetServiceClientMock(findServiceDelay: 0.1, ip: "ip", port: "port")
        let sut = NetServiceConnectionChecker(netServiceClient: clientMock, rtspConfiguration: configuration)
        let connection = sut.connectionStatus.share(replay: 1, scope: .whileConnected)
        
        // When
        connection.fulfill(expectation: exp, afterEventCount: 1, bag: bag) {
            sut.stop()
        }
        connection.subscribe(observer).disposed(by: bag)
        scheduler.start()
        sut.start()
        
        // Then
        waitForExpectations(timeout: 0.2) { _ in
            XCTAssertRecordedElements(observer.events, [.connected])
        }
    }
    
    func testShouldUpdateStatusToDisconnectedIfDeviceIsNotFound() {
        // Given
        let exp = expectation(description: "Should update status")
        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(ConnectionStatus.self)
        let configuration = RTSPConfigurationMock()
        configuration.url = URL(string: "rtsp://ip:port")
        let clientMock = NetServiceClientMock(findServiceDelay: 20, ip: "ip", port: "port")
        let sut = NetServiceConnectionChecker(netServiceClient: clientMock, rtspConfiguration: configuration, delay: 0.1)
        let connection = sut.connectionStatus.share(replay: 1, scope: .whileConnected)
        
        // When
        connection.fulfill(expectation: exp, afterEventCount: 1, bag: bag) {
            sut.stop()
        }
        connection.subscribe(observer).disposed(by: bag)
        scheduler.start()
        sut.start()
        
        // Then
        waitForExpectations(timeout: 0.15) { _ in
            XCTAssertRecordedElements(observer.events, [.disconnected])
        }
    }
    
    func testShouldUpdateStatusToConnectedTwiceIfDeviceIsFound() {
        // Given
        let exp = expectation(description: "Should update status")
        let exp2 = expectation(description: "Should update status twice")
        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(ConnectionStatus.self)
        let configuration = RTSPConfigurationMock()
        configuration.url = URL(string: "rtsp://ip:port")
        let clientMock = NetServiceClientMock(findServiceDelay: 0.1, ip: "ip", port: "port")
        let sut = NetServiceConnectionChecker(netServiceClient: clientMock, rtspConfiguration: configuration, delay: 0.2)
        let connection = sut.connectionStatus.share(replay: 1, scope: .whileConnected)
        
        // When
        connection.fulfill(expectation: exp, afterEventCount: 1, bag: bag)
        connection.fulfill(expectation: exp2, afterEventCount: 2, bag: bag) {
            sut.stop()
        }
        connection.subscribe(observer).disposed(by: bag)
        scheduler.start()
        sut.start()
        
        // Then
        waitForExpectations(timeout: 0.3) { _ in
            XCTAssertRecordedElements(observer.events, [.connected, .connected])
        }
    }
    
    func testShouldUpdateStatusToConnectedAndThenDisconnectedIfDeviceIsLost() {
        // Given
        let exp = expectation(description: "Should update status")
        let exp2 = expectation(description: "Should update status twice")
        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(ConnectionStatus.self)
        let configuration = RTSPConfigurationMock()
        configuration.url = URL(string: "rtsp://ip:port")
        let clientMock = NetServiceClientMock(findServiceDelay: 0.1, ip: "ip", port: "port")
        let sut = NetServiceConnectionChecker(netServiceClient: clientMock, rtspConfiguration: configuration, delay: 0.15)
        let connection = sut.connectionStatus.share(replay: 1, scope: .whileConnected)
        
        // When
        connection.fulfill(expectation: exp, afterEventCount: 1, bag: bag) {
            clientMock.stopFinding()
        }
        connection.fulfill(expectation: exp2, afterEventCount: 2, bag: bag) {
            sut.stop()
        }
        connection.subscribe(observer).disposed(by: bag)
        scheduler.start()
        sut.start()
        
        // Then
        waitForExpectations(timeout: 0.3) { _ in
            XCTAssertRecordedElements(observer.events, [.connected, .disconnected])
        }
    }
    
    func testShouldUpdateStatusToDisconnectedAndThenConnectedIfDeviceIsFoundAfterSomeTime() {
        // Given
        let exp = expectation(description: "Should update status")
        let exp2 = expectation(description: "Should update status twice")
        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(ConnectionStatus.self)
        let configuration = RTSPConfigurationMock()
        configuration.url = URL(string: "rtsp://ip:port")
        let clientMock = NetServiceClientMock(findServiceDelay: 5.0, ip: "ip", port: "port")
        let sut = NetServiceConnectionChecker(netServiceClient: clientMock, rtspConfiguration: configuration, delay: 0.15)
        let connection = sut.connectionStatus.share(replay: 1, scope: .whileConnected)
        
        // When
        connection.fulfill(expectation: exp, afterEventCount: 1, bag: bag) {
            clientMock.forceFind()
        }
        connection.fulfill(expectation: exp2, afterEventCount: 2, bag: bag) {
            sut.stop()
        }
        connection.subscribe(observer).disposed(by: bag)
        scheduler.start()
        sut.start()
        
        // Then
        waitForExpectations(timeout: 0.3) { _ in
            XCTAssertRecordedElements(observer.events, [.disconnected, .connected])
        }
    }
    
}
