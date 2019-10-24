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
        let sdpOffer = SessionDescriptionMock(sdp: "sdp", stringType: "answer")
        let peerConnection = PeerConnectionMock()
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection)
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory)

        // When
        sut.start()
        sut.createAnswer(remoteSdp: sdpOffer)
        sut.stop()

        // Then
        XCTAssertFalse(peerConnection.isConnected)
    }

    func testShouldSetOfferWhenCreatingAnswer() {
        // Given
        let sdpOffer = SessionDescriptionMock(sdp: "sdp", stringType: "answer")
        let peerConnection = PeerConnectionMock()
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection)
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory)

        // When
        sut.start()
        sut.createAnswer(remoteSdp: sdpOffer)

        // Then
        XCTAssertEqual(sdpOffer, peerConnection.remoteSdp as! SessionDescriptionMock)
    }

    func testShouldEmitStreamWhenCreatingAnswer() {
        // Given
        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(MediaStream.self)
        let sdpOffer = SessionDescriptionMock(sdp: "sdp", stringType: "answer")
        let peerConnection = PeerConnectionMock()
        let streamId = "test"
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection, mediaStream: streamId as MediaStream)
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory)

        sut.mediaStream
            .subscribe(observer)
            .disposed(by: bag)

        // When
        sut.start()
        sut.createAnswer(remoteSdp: sdpOffer)

        // Then
        XCTAssertEqual([streamId], observer.events.map { ($0.value.element as! String) })
    }
}
