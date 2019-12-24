//
//  OnboardingCompareCodeViewModelTests.swift
//  Baby MonitorTests
//


import XCTest
import RealmSwift
import RxSwift
import RxTest
@testable import BabyMonitor

class OnboardingCompareCodeViewModelTests: XCTestCase {

    func testShouldSaveUrlOfFoundDeviceToConfigurationAndSendCode() throws {
        // Given
        let webSocketEventMessageServiceMock = WebSocketEventMessageServiceMock()
        let url = URL(string: "ws://ip:port")
        let configuration = URLConfigurationMock()
        let babyRepo = RealmBabiesRepository(realm: try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test-realm")))
        let sut = OnboardingCompareCodeViewModel(
            webSocketEventMessageService: webSocketEventMessageServiceMock,
            urlConfiguration: configuration,
            serverURL: try XCTUnwrap(url),
            activityLogEventsRepository: babyRepo
        )
        let codeEvent = EventMessage(action: BabyMonitorEvent.pairingCodeKey.rawValue, value: sut.codeText)

        // When
        sut.sendCode()

        // Then
        XCTAssertNotNil(configuration.url)
        XCTAssertTrue(webSocketEventMessageServiceMock.isOpen)
        XCTAssertEqual(webSocketEventMessageServiceMock.messages, [codeEvent.toStringMessage()])
    }

    func testShouldSendEmptyCodeOnCancelPairing() throws {
        // Given
        let webSocketEventMessageServiceMock = WebSocketEventMessageServiceMock()
        let url = URL(string: "ws://ip:port")
        let configuration = URLConfigurationMock()
        let babyRepo = RealmBabiesRepository(realm: try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test-realm")))
        let emptyEvent = EventMessage(action: BabyMonitorEvent.pairingCodeKey.rawValue, value: "")
        let sut = OnboardingCompareCodeViewModel(
            webSocketEventMessageService: webSocketEventMessageServiceMock,
            urlConfiguration: configuration,
            serverURL: try XCTUnwrap(url),
            activityLogEventsRepository: babyRepo
        )

        // When
        sut.cancelPairingAttempt()

        // Then
        XCTAssertEqual(webSocketEventMessageServiceMock.messages, [emptyEvent.toStringMessage()])
        XCTAssertFalse(webSocketEventMessageServiceMock.isOpen)
    }
    
}
