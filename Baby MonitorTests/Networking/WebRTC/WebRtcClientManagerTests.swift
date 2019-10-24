//
//  WebRtcClientManagerTests.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import XCTest
import RxSwift
import RxTest

class WebRtcClientManagerTests: XCTestCase {

    func testShouldCreateOfferOnStart() {
        // Given
        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(SessionDescriptionProtocol.self)
        let offerSdp = SessionDescriptionMock(sdp: "sdp", stringType: "offer")
        let peerConnection = PeerConnectionMock(offerSdp: offerSdp)
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection)
        let connectionChecker = ConnectionCheckerMock()
        let appStateProvider = ApplicationStateProviderMock()
        let sut = WebRtcClientManager(peerConnectionFactory: peerConnectionFactory, connectionChecker: connectionChecker, appStateProvider: appStateProvider)

        // When
        sut.sdpOffer
            .subscribe(observer)
            .disposed(by: bag)
        scheduler.start()
        sut.startIfNeeded()

        // Then
        XCTAssertEqual(observer.events.map { $0.value.element!.sdp }, [offerSdp.sdp])
    }

    func testShouldSetAnswer() {
        // Given
        let answerSdp = SessionDescriptionMock(sdp: "sdp", stringType: "type")
        let peerConnection = PeerConnectionMock()
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection)
        let connectionChecker = ConnectionCheckerMock()
        let appStateProvider = ApplicationStateProviderMock()
        let sut = WebRtcClientManager(peerConnectionFactory: peerConnectionFactory, connectionChecker: connectionChecker, appStateProvider: appStateProvider)

        // When
        sut.startIfNeeded()
        sut.setAnswerSDP(sdp: answerSdp)

        // Then
        XCTAssertEqual(answerSdp.sdp, peerConnection.remoteSdp!.sdp)
    }

    func testShouldDisconnect() {
        // Given
        let peerConnection = PeerConnectionMock()
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection)
        let connectionChecker = ConnectionCheckerMock()
        let appStateProvider = ApplicationStateProviderMock()
        let sut = WebRtcClientManager(peerConnectionFactory: peerConnectionFactory, connectionChecker: connectionChecker, appStateProvider: appStateProvider)

        // When
        sut.startIfNeeded()
        sut.stop()

        // Then
        XCTAssertFalse(peerConnection.isConnected)
    }
}
