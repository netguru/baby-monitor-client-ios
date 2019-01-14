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
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection)
        let connectionDelegateProxy = PeerConnectionDelegateProxy()
        let sessionDelegateProxy = SessionDescriptionDelegateProxy()
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory, connectionDelegateProxy: connectionDelegateProxy, sessionDelegateProxy: sessionDelegateProxy)
        connectionDelegateProxy.delegate = sut
        sessionDelegateProxy.delegate = sut

        // When
        sut.disconnect()

        // Then
        XCTAssertFalse(peerConnection.isConnected)
    }

    func testShouldAddIceCandidate() {
        // Given
        let iceCandidate = IceCandidateMock(sdpMLineIndex: 0, sdpMid: "", sdp: "sdp")
        let peerConnection = PeerConnectionMock()
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection)
        let connectionDelegateProxy = PeerConnectionDelegateProxy()
        let sessionDelegateProxy = SessionDescriptionDelegateProxy()
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory, connectionDelegateProxy: connectionDelegateProxy, sessionDelegateProxy: sessionDelegateProxy)
        connectionDelegateProxy.delegate = sut
        sessionDelegateProxy.delegate = sut
        // When
        sut.setICECandidates(iceCandidate: iceCandidate)

        // Then
        XCTAssertEqual([iceCandidate], peerConnection.iceCandidates.map { $0 as! IceCandidateMock })
    }

    func testShouldSetOfferWhenCreatingAnswer() {
        // Given
        let sdpOffer = SessionDescriptionMock(sdp: "sdp", stringType: "answer")
        let peerConnection = PeerConnectionMock()
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection)
        let connectionDelegateProxy = PeerConnectionDelegateProxy()
        let sessionDelegateProxy = SessionDescriptionDelegateProxy()
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory, connectionDelegateProxy: connectionDelegateProxy, sessionDelegateProxy: sessionDelegateProxy)
        connectionDelegateProxy.delegate = sut
        sessionDelegateProxy.delegate = sut
        // When
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
        let connectionDelegateProxy = PeerConnectionDelegateProxy()
        let sessionDelegateProxy = SessionDescriptionDelegateProxy()
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory, connectionDelegateProxy: connectionDelegateProxy, sessionDelegateProxy: sessionDelegateProxy)
        connectionDelegateProxy.delegate = sut
        sessionDelegateProxy.delegate = sut
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
