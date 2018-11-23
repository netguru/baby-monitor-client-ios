//
//  WebRtcServerManagerTests.swift
//  Baby MonitorTests
//

import XCTest
@testable import BabyMonitor
import RxSwift
import RxTest

class WebRtcServerManagerTests: XCTestCase {

    func testShouldDisconnect() {
        // Given
        let peerConnection = PeerConnectionMock()
        let streamFactory = StreamFactoryMock()
        let sut = WebRtcServerManager(peerConnection: peerConnection, streamFactory: streamFactory)

        // When
        sut.disconnect()

        // Then
        XCTAssertFalse(peerConnection.isConnected)
    }

    func testShouldAddIceCandidate() {
        // Given
        let iceCandidate = IceCandidateMock(sdpMLineIndex: Int32(0), sdpMid: "", sdp: "sdp")
        let peerConnection = PeerConnectionMock()
        let streamFactory = StreamFactoryMock()
        let sut = WebRtcServerManager(peerConnection: peerConnection, streamFactory: streamFactory)

        // When
        sut.setICECandidates(iceCandidate: iceCandidate)

        // Then
        XCTAssertEqual([iceCandidate], peerConnection.iceCandidates.map { $0 as! IceCandidateMock })
    }

    func testShouldSetOfferWhenCreatingAnswer() {
        // Given
        let sdpOffer = SessionDescriptionMock(sdp: "sdp", stringType: "answer")
        let peerConnection = PeerConnectionMock()
        let streamFactory = StreamFactoryMock()
        let sut = WebRtcServerManager(peerConnection: peerConnection, streamFactory: streamFactory)

        // When
        sut.createAnswer(remoteSdp: sdpOffer)

        // Then
        XCTAssertEqual(sdpOffer, peerConnection.remoteSdp as! SessionDescriptionMock)
    }

    func testShouldAddStreamToConnectionWhenCreatingAnswer() {
        // Given
        let sdpOffer = SessionDescriptionMock(sdp: "sdp", stringType: "answer")
        let peerConnection = PeerConnectionMock()
        let streamId = "test"
        let streamFactory = StreamFactoryMock(id: streamId)
        let sut = WebRtcServerManager(peerConnection: peerConnection, streamFactory: streamFactory)

        // When
        sut.createAnswer(remoteSdp: sdpOffer)

        // Then
        XCTAssertEqual(streamId, (peerConnection.mediaStream as! MediaStreamMock).id)
    }

    func testShouldEmitStreamWhenCreatingAnswer() {
        // Given
        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(MediaStreamProtocol.self)
        let sdpOffer = SessionDescriptionMock(sdp: "sdp", stringType: "answer")
        let peerConnection = PeerConnectionMock()
        let streamId = "test"
        let streamFactory = StreamFactoryMock(id: streamId)
        let sut = WebRtcServerManager(peerConnection: peerConnection, streamFactory: streamFactory)
        sut.mediaStream
            .subscribe(observer)
            .disposed(by: bag)

        // When
        sut.createAnswer(remoteSdp: sdpOffer)

        // Then
        XCTAssertEqual([streamId], observer.events.map { $0.value.element as! MediaStreamMock }.map { $0.id })
    }
}
