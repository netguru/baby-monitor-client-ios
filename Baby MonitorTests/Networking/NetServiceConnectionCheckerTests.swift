//
//  NetServiceConnectionCheckerTests.swift
//  Baby MonitorTests
//

import XCTest
@testable import BabyMonitor

class NetServiceConnectionCheckerTests: XCTestCase {
    
    func testShouldUpdateStatusToConnectedIfDeviceIsFound() {
        // Given
        let exp = expectation(description: "Should update status")
        let configuration = RTSPConfigurationMock()
        configuration.url = URL(string: "rtsp://ip:port")
        let clientMock = NetServiceClientMock(findServiceDelay: 0.1, ip: "ip", port: "port")
        let sut = NetServiceConnectionChecker(netServiceClient: clientMock, rtspConfiguration: configuration)
        
        // When
        sut.didUpdateStatus = { status in
            sut.stop()
            XCTAssertEqual(.connected, status)
            exp.fulfill()
        }
        sut.start()
        
        // Then
        waitForExpectations(timeout: 0.2)
    }
    
    func testShouldUpdateStatusToDisconnectedIfDeviceIsNotFound() {
        // Given
        let exp = expectation(description: "Should update status")
        let configuration = RTSPConfigurationMock()
        configuration.url = URL(string: "rtsp://ip:port")
        let clientMock = NetServiceClientMock(findServiceDelay: 20, ip: "ip", port: "port")
        let sut = NetServiceConnectionChecker(netServiceClient: clientMock, rtspConfiguration: configuration, delay: 0.1)
        
        // When
        sut.didUpdateStatus = { status in
            sut.stop()
            XCTAssertEqual(.disconnected, status)
            exp.fulfill()
        }
        sut.start()
        
        // Then
        waitForExpectations(timeout: 0.15)
    }
    
    func testShouldUpdateStatusToConnectedTwiceIfDeviceIsFound() {
        // Given
        let exp = expectation(description: "Should update status")
        var updated = false
        let exp2 = expectation(description: "Should update status twice")
        let configuration = RTSPConfigurationMock()
        configuration.url = URL(string: "rtsp://ip:port")
        let clientMock = NetServiceClientMock(findServiceDelay: 0.1, ip: "ip", port: "port")
        let sut = NetServiceConnectionChecker(netServiceClient: clientMock, rtspConfiguration: configuration, delay: 0.2)
        
        // When
        sut.didUpdateStatus = { status in
            XCTAssertEqual(.connected, status)
            if !updated {
                exp.fulfill()
                updated = true
            } else {
                exp2.fulfill()
                sut.stop()
            }
        }
        sut.start()
        
        // Then
        waitForExpectations(timeout: 0.3)
    }
    
    func testShouldUpdateStatusToConnectedAndThenDisconnectedIfDeviceIsLost() {
        // Given
        let exp = expectation(description: "Should update status")
        var updated = false
        let exp2 = expectation(description: "Should update status twice")
        let configuration = RTSPConfigurationMock()
        configuration.url = URL(string: "rtsp://ip:port")
        let clientMock = NetServiceClientMock(findServiceDelay: 0.1, ip: "ip", port: "port")
        let sut = NetServiceConnectionChecker(netServiceClient: clientMock, rtspConfiguration: configuration, delay: 0.15)
        
        // When
        sut.didUpdateStatus = { status in
            if !updated {
                XCTAssertEqual(.connected, status)
                exp.fulfill()
                updated = true
                clientMock.stopFinding()
            } else {
                XCTAssertEqual(.disconnected, status)
                exp2.fulfill()
                sut.stop()
            }
        }
        sut.start()
        
        // Then
        waitForExpectations(timeout: 0.3)
    }
    
    func testShouldUpdateStatusToDisconnectedAndThenConnectedIfDeviceIsFoundAfterSomeTime() {
        // Given
        let exp = expectation(description: "Should update status")
        var updated = false
        let exp2 = expectation(description: "Should update status twice")
        let configuration = RTSPConfigurationMock()
        configuration.url = URL(string: "rtsp://ip:port")
        let clientMock = NetServiceClientMock(findServiceDelay: 5.0, ip: "ip", port: "port")
        let sut = NetServiceConnectionChecker(netServiceClient: clientMock, rtspConfiguration: configuration, delay: 0.15)
        
        // When
        sut.didUpdateStatus = { status in
            if !updated {
                XCTAssertEqual(.disconnected, status)
                exp.fulfill()
                clientMock.forceFind(delay: 0.1)
                updated = true
            } else {
                XCTAssertEqual(.connected, status)
                exp2.fulfill()
                sut.stop()
            }
        }
        sut.start()
        
        // Then
        waitForExpectations(timeout: 0.3)
    }

}
