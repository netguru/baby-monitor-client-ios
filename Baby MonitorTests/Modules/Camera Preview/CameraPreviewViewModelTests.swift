//
//  CameraPreviewViewModelTests.swift
//  Baby MonitorTests

import Foundation
import XCTest
import RxSwift
import RxTest
@testable import BabyMonitor

class CameraPreviewViewModelTests: XCTestCase {

    // swiftlint:disable implicitly_unwrapped_optional
    private var webSocketWebRtcServiceMock: WebSocketWebRtcServiceMock!
    private var webSocketWebRtcService: ClearableLazyItem<WebSocketWebRtcServiceProtocol>!
    private var babyModelController: BabyModelControllerProtocol!
    private var socketCommunicationManager: SocketCommunicationManager!
    private var webSocketEventMessageService: WebSocketEventMessageServiceProtocol!
    private var permissionsService: PermissionsProviderMock!
    private var analytics: AnalyticsManager!

    private var cancelTap: Observable<Void>!
    private var settingsTap: Observable<Void>!
    private var microphoneHoldEvent: PublishSubject<Void>!
    private var microphoneReleaseEvent: PublishSubject<Void>!

    private var sut: CameraPreviewViewModel!

    private var disposeBag: DisposeBag!

    // swiftlint:enable implicitly_unwrapped_optional

    override func setUp() {
        webSocketWebRtcServiceMock = WebSocketWebRtcServiceMock()
        webSocketWebRtcService = ClearableLazyItem(constructor: { return self.webSocketWebRtcServiceMock })
        babyModelController = DatabaseRepositoryMock()
        socketCommunicationManager = SocketCommunicationManagerMock()
        webSocketEventMessageService = WebSocketEventMessageServiceMock()
        permissionsService = PermissionsProviderMock()
        analytics = AnalyticsManager(analyticsTracker: AnalyticsTrackerMock())

        sut = CameraPreviewViewModel(webSocketWebRtcService: webSocketWebRtcService,
                                     babyModelController: babyModelController,
                                     socketCommunicationManager: socketCommunicationManager,
                                     webSocketEventMessageService: webSocketEventMessageService,
                                     permissionsService: permissionsService,
                                     analytics: analytics)

        cancelTap = PublishSubject<Void>()
        settingsTap = PublishSubject<Void>()
        microphoneHoldEvent = PublishSubject<Void>()
        microphoneReleaseEvent = PublishSubject<Void>()

        disposeBag = DisposeBag()

        sut.attachInput(cancelTap: cancelTap,
                        settingsTap: settingsTap,
                        microphoneHoldEvent: microphoneHoldEvent,
                        microphoneReleaseEvent: microphoneReleaseEvent)
    }

    func testShouldStartAudioTransmittingWhenAccessGranted() {
        // Given
        permissionsService.isMicrophoneAccessGranted = true

        // When
        microphoneHoldEvent.onNext(())

        // Then
        XCTAssertTrue(webSocketWebRtcServiceMock.didAddAudioTrack)
    }

    func testShouldNotStartAudioTransmittingWhenNoAccessGranted() {
        // Given
        permissionsService.isMicrophoneAccessGranted = false

        // When
        microphoneHoldEvent.onNext(())

        // Then
        XCTAssertFalse(webSocketWebRtcServiceMock.didAddAudioTrack)
    }

    func testShouldNotifyWhenTriedToTransmittAndNoAccessGranted() {
        // Given
        permissionsService.isMicrophoneAccessGranted = false
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)
        sut.noMicrophoneAccessPublisher.bind(to: observer).disposed(by: disposeBag)

        // When
        microphoneHoldEvent.onNext(())

        // Then
        XCTAssertTrue(observer.events.isNotEmpty)
    }

    func testStopTransmittingAudioOnRelease() {
         // Given
         permissionsService.isMicrophoneAccessGranted = true

         // When
         microphoneReleaseEvent.onNext(())

         // Then
         XCTAssertTrue(webSocketWebRtcServiceMock.didStopAudioTrack)
     }
}
