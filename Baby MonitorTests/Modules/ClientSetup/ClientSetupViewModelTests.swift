//
//  ClientSetupViewModelTests.swift
//  Baby MonitorTests
//

import XCTest
@testable import BabyMonitor

class ClientSetupViewModelTests: XCTestCase {

    func testShouldStartNetClientDiscoverAfterSelect() {
        // Given
        let exp = expectation(description: "Should find device")
        let netServiceClient = NetServiceClientMock()
        let configuration = RTSPConfigurationMock()
        let sut = ClientSetupViewModel(netServiceClient: netServiceClient, rtspConfiguration: configuration)
        sut.didEndDeviceSearch = { _ in exp.fulfill() }
        
        // When
        sut.selectStartDiscovering()
        
        // Then
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertTrue(netServiceClient.didCallFindService)
        }
    }
    
    func testShouldSaveUrlOfFoundDeviceToConfiguration() {
        // Given
        let exp = expectation(description: "Should find device")
        let ip = "ip"
        let port = "port"
        let netServiceClient = NetServiceClientMock(ip: ip, port: port)
        let configuration = RTSPConfigurationMock()
        let sut = ClientSetupViewModel(netServiceClient: netServiceClient, rtspConfiguration: configuration)
        sut.didEndDeviceSearch = { _ in exp.fulfill() }
        
        // When
        sut.selectStartDiscovering()
        
        // Then
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertNotNil(configuration.url)
            XCTAssertEqual(URL(string: "rtsp://\(ip):\(port)"), configuration.url)
        }
    }
    
    func testShouldCallDidFindDeviceAfterFindingDevice() {
        // Given
        let exp = expectation(description: "Should find device")
        let netServiceClient = NetServiceClientMock()
        let configuration = RTSPConfigurationMock()
        let sut = ClientSetupViewModel(netServiceClient: netServiceClient, rtspConfiguration: configuration)
        sut.didEndDeviceSearch = { _ in exp.fulfill() }
        
        // When
        sut.selectStartDiscovering()
        
        // Then
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertNotNil(configuration.url)
        }
    }
    
    func testShouldCallDidStartFindingDeviceAfterSelect() {
        // Given
        let exp = expectation(description: "Should find device")
        let startFindExp = expectation(description: "Should start device search")
        let netServiceClient = NetServiceClientMock()
        let configuration = RTSPConfigurationMock()
        let sut = ClientSetupViewModel(netServiceClient: netServiceClient, rtspConfiguration: configuration)
        sut.didEndDeviceSearch = { _ in exp.fulfill() }
        sut.didStartDeviceSearch = { startFindExp.fulfill() }
        
        // When
        sut.selectStartDiscovering()
        
        // Then
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertTrue(true)
        }
    }
    
    func testShouldEndSearchWithFailureAfterGivenTime() {
        // Given
        let exp = expectation(description: "Should find device")
        let startFindExp = expectation(description: "Should start device search")
        let netServiceClient = NetServiceClientMock(findServiceDelay: 20.0)
        let configuration = RTSPConfigurationMock()
        let sut = ClientSetupViewModel(netServiceClient: netServiceClient, rtspConfiguration: configuration)
        sut.didEndDeviceSearch = { result in
            XCTAssertEqual(result, DeviceSearchResult.failure(.timeout))
            exp.fulfill()
        }
        sut.didStartDeviceSearch = { startFindExp.fulfill() }
        
        // When
        sut.selectStartDiscovering(withTimeout: 0.1)
        
        // Then
        waitForExpectations(timeout: 0.2) { _ in
            XCTAssertTrue(true)
        }
    }
}
