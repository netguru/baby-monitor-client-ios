//
//  ClientSetupViewModelTests.swift
//  Baby MonitorTests
//

import XCTest
import RealmSwift
@testable import BabyMonitor

class ClientSetupViewModelTests: XCTestCase {

    func testShouldStartNetClientDiscoverAfterSelect() {
        // Given
        let exp = expectation(description: "Should find device")
        let netServiceClient = NetServiceClientMock()
        let configuration = URLConfigurationMock()
        let babyRepo = RealmBabiesRepository(realm: try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test-realm")))
        let webSocketEventMessageService = WebSocketEventMessageServiceMock()
        let errorLogger = ServerErrorLoggerMock()
        let sut = ClientSetupOnboardingViewModel(netServiceClient: netServiceClient, urlConfiguration: configuration, activityLogEventsRepository: babyRepo, webSocketEventMessageService: webSocketEventMessageService, serverErrorLogger: errorLogger)
        sut.didFinishDeviceSearch = { _ in exp.fulfill() }

        // When
        sut.startDiscovering()
        netServiceClient.serviceRelay.accept((ip: "0.0.0.0", port: "0"))
        
        // Then
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertTrue(netServiceClient.isEnabled.value)
        }
    }
    
    func testShouldSaveUrlOfFoundDeviceToConfiguration() {
        // Given
        let exp = expectation(description: "Should find device")
        let ip = "ip"
        let port = "port"
        let netServiceClient = NetServiceClientMock()
        let configuration = URLConfigurationMock()
        let babyRepo = RealmBabiesRepository(realm: try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test-realm")))
        let webSocketEventMessageService = WebSocketEventMessageServiceMock()
        let errorLogger = ServerErrorLoggerMock()
        let sut = ClientSetupOnboardingViewModel(netServiceClient: netServiceClient, urlConfiguration: configuration, activityLogEventsRepository: babyRepo, webSocketEventMessageService: webSocketEventMessageService, serverErrorLogger: errorLogger)
        sut.didFinishDeviceSearch = { _ in exp.fulfill() }
        
        // When
        sut.startDiscovering()
        netServiceClient.serviceRelay.accept((ip: ip, port: port))
        
        // Then
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertNotNil(configuration.url)
            XCTAssertEqual(URL(string: "ws://\(ip):\(port)"), configuration.url)
        }
    }
    
    func testShouldCallDidFindDeviceAfterFindingDevice() {
        // Given
        let exp = expectation(description: "Should find device")
        let netServiceClient = NetServiceClientMock()
        let configuration = URLConfigurationMock()
        let babyRepo = RealmBabiesRepository(realm: try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test-realm")))
        let webSocketEventMessageService = WebSocketEventMessageServiceMock()
        let errorLogger = ServerErrorLoggerMock()
        let sut = ClientSetupOnboardingViewModel(netServiceClient: netServiceClient, urlConfiguration: configuration, activityLogEventsRepository: babyRepo, webSocketEventMessageService: webSocketEventMessageService, serverErrorLogger: errorLogger)
        sut.didFinishDeviceSearch = { _ in exp.fulfill() }
        
        // When
        sut.startDiscovering()
        netServiceClient.serviceRelay.accept((ip: "0.0.0.0", port: "0"))
        
        // Then
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertNotNil(configuration.url)
        }
    }
    
    func testShouldCallDidStartFindingDeviceAfterSelect() {
        // Given
        let exp = expectation(description: "Should find device")
        let netServiceClient = NetServiceClientMock()
        let configuration = URLConfigurationMock()
        let babyRepo = RealmBabiesRepository(realm: try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test-realm")))
        let webSocketEventMessageService = WebSocketEventMessageServiceMock()
        let errorLogger = ServerErrorLoggerMock()
        let sut = ClientSetupOnboardingViewModel(netServiceClient: netServiceClient, urlConfiguration: configuration, activityLogEventsRepository: babyRepo, webSocketEventMessageService: webSocketEventMessageService, serverErrorLogger: errorLogger)
        sut.didFinishDeviceSearch = { _ in exp.fulfill() }
        
        // When
        sut.startDiscovering()
        netServiceClient.serviceRelay.accept((ip: "0.0.0.0", port: "0"))
        
        // Then
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertTrue(true)
        }
    }
    
    func testShouldEndSearchWithFailureAfterGivenTime() {
        // Given
        let exp = expectation(description: "Should find device")
        let netServiceClient = NetServiceClientMock()
        let configuration = URLConfigurationMock()
        let babyRepo = RealmBabiesRepository(realm: try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test-realm")))
        let webSocketEventMessageService = WebSocketEventMessageServiceMock()
        let errorLogger = ServerErrorLoggerMock()
        let sut = ClientSetupOnboardingViewModel(netServiceClient: netServiceClient, urlConfiguration: configuration, activityLogEventsRepository: babyRepo, webSocketEventMessageService: webSocketEventMessageService, serverErrorLogger: errorLogger)
        sut.didFinishDeviceSearch = { result in
            XCTAssertEqual(result, DeviceSearchResult.failure(.timeout))
            exp.fulfill()
        }
        
        // When
        sut.startDiscovering(withTimeout: 0.1)
        
        // Then
        waitForExpectations(timeout: 0.2) { _ in
            XCTAssertTrue(true)
        }
    }
}
