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
        let analyticsMock = AnalyticsManager(analyticsTracker: AnalyticsTrackerMock())
        let sut = OnboardingCompareCodeViewModel(
            webSocketEventMessageService: webSocketEventMessageServiceMock,
            urlConfiguration: configuration,
            serverURL: try XCTUnwrap(url),
            activityLogEventsRepository: babyRepo,
            analytics: analyticsMock
        )
        let codeEvent = EventMessage(pairingCode: sut.codeText)

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
        let emptyEvent = EventMessage(pairingCode: "")
        let analyticsMock = AnalyticsManager(analyticsTracker: AnalyticsTrackerMock())
        let sut = OnboardingCompareCodeViewModel(
            webSocketEventMessageService: webSocketEventMessageServiceMock,
            urlConfiguration: configuration,
            serverURL: try XCTUnwrap(url),
            activityLogEventsRepository: babyRepo,
            analytics: analyticsMock
        )

        // When
        sut.cancelPairingAttempt()

        // Then
        XCTAssertEqual(webSocketEventMessageServiceMock.messages, [emptyEvent.toStringMessage()])
        XCTAssertFalse(webSocketEventMessageServiceMock.isOpen)
    }
    
    func testShouldCloseConnectionOnDeclinedPairing() throws {
        // Given
        let disposeBag = DisposeBag()
        let webSocketEventMessageServiceMock = WebSocketEventMessageServiceMock()
        let url = URL(string: "ws://ip:port")
        let configuration = URLConfigurationMock()
        let babyRepo = RealmBabiesRepository(realm: try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test-realm")))
        let analyticsMock = AnalyticsManager(analyticsTracker: AnalyticsTrackerMock())
        let sut = OnboardingCompareCodeViewModel(
            webSocketEventMessageService: webSocketEventMessageServiceMock,
            urlConfiguration: configuration,
            serverURL: try XCTUnwrap(url),
            activityLogEventsRepository: babyRepo,
            analytics: analyticsMock
        )
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        webSocketEventMessageServiceMock.remotePairingCodeResponseObservable
            .bind(to: observer)
            .disposed(by: disposeBag)

        // When
        sut.sendCode()
        webSocketEventMessageServiceMock.remotePairingCodeResponsePublisher.onNext(false)
        scheduler.start()

        // Then
        XCTAssertFalse(webSocketEventMessageServiceMock.isOpen)
    }
}
