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
        let offerSdp = SessionDescriptionMock(sdp: "sdp", stringType: "type")
        let peerConnection = PeerConnectionMock(offerSdp: offerSdp)
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection)
        let connectionDelegateProxy = PeerConnectionDelegateProxy()
        let sessionDelegateProxy = SessionDescriptionDelegateProxy()
        let sut = WebRtcClientManager(peerConnectionFactory: peerConnectionFactory, connectionDelegateProxy: connectionDelegateProxy, sessionDelegateProxy: sessionDelegateProxy)
        connectionDelegateProxy.delegate = sut
        sessionDelegateProxy.delegate = sut

        // When
        sut.sdpOffer
            .subscribe(observer)
            .disposed(by: bag)
        scheduler.start()
        sut.startWebRtcConnectionIfNeeded()

        // Then
        XCTAssertEqual(observer.events.map { $0.value.element!.sdp }, [offerSdp.sdp])
    }

    func testShouldSetAnswer() {
        // Given
        let answerSdp = SessionDescriptionMock(sdp: "sdp", stringType: "type")
        let peerConnection = PeerConnectionMock()
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection)
        let connectionDelegateProxy = PeerConnectionDelegateProxy()
        let sessionDelegateProxy = SessionDescriptionDelegateProxy()
        let sut = WebRtcClientManager(peerConnectionFactory: peerConnectionFactory, connectionDelegateProxy: connectionDelegateProxy, sessionDelegateProxy: sessionDelegateProxy)
        connectionDelegateProxy.delegate = sut
        sessionDelegateProxy.delegate = sut

        // When
        sut.startWebRtcConnectionIfNeeded()
        sut.setAnswerSDP(sdp: answerSdp)

        // Then
        XCTAssertEqual(answerSdp.sdp, peerConnection.remoteSdp!.sdp)
    }

    func testShouldAddIceCandidate() {
        // Given
        let iceCandidate = IceCandidateMock(sdpMLineIndex: 0, sdpMid: "", sdp: "sdp")
        let peerConnection = PeerConnectionMock()
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection)
        let connectionDelegateProxy = PeerConnectionDelegateProxy()
        let sessionDelegateProxy = SessionDescriptionDelegateProxy()
        let sut = WebRtcClientManager(peerConnectionFactory: peerConnectionFactory, connectionDelegateProxy: connectionDelegateProxy, sessionDelegateProxy: sessionDelegateProxy)
        connectionDelegateProxy.delegate = sut
        sessionDelegateProxy.delegate = sut

        // When
        sut.startWebRtcConnectionIfNeeded()
        sut.setICECandidates(iceCandidate: iceCandidate)

        // Then
        XCTAssertEqual([iceCandidate], peerConnection.iceCandidates as! [IceCandidateMock])
    }

    func testShouldAddMultipleIceCandidate() {
        // Given
        let iceCandidate = IceCandidateMock(sdpMLineIndex: 0, sdpMid: "", sdp: "sdp")
        let secondIceCandidate = IceCandidateMock(sdpMLineIndex: 0, sdpMid: "", sdp: "sdp2")
        let peerConnection = PeerConnectionMock()
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection)
        let connectionDelegateProxy = PeerConnectionDelegateProxy()
        let sessionDelegateProxy = SessionDescriptionDelegateProxy()
        let sut = WebRtcClientManager(peerConnectionFactory: peerConnectionFactory, connectionDelegateProxy: connectionDelegateProxy, sessionDelegateProxy: sessionDelegateProxy)
        connectionDelegateProxy.delegate = sut
        sessionDelegateProxy.delegate = sut

        // When
        sut.startWebRtcConnectionIfNeeded()
        sut.setICECandidates(iceCandidate: iceCandidate)
        sut.setICECandidates(iceCandidate: secondIceCandidate)

        // Then
        XCTAssertEqual([iceCandidate, secondIceCandidate], peerConnection.iceCandidates as! [IceCandidateMock])
    }

    func testShouldDisconnect() {
        // Given
        let peerConnection = PeerConnectionMock()
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection)
        let connectionDelegateProxy = PeerConnectionDelegateProxy()
        let sessionDelegateProxy = SessionDescriptionDelegateProxy()
        let sut = WebRtcClientManager(peerConnectionFactory: peerConnectionFactory, connectionDelegateProxy: connectionDelegateProxy, sessionDelegateProxy: sessionDelegateProxy)
        connectionDelegateProxy.delegate = sut
        sessionDelegateProxy.delegate = sut

        // When
        sut.startWebRtcConnectionIfNeeded()
        sut.disconnect()

        // Then
        XCTAssertFalse(peerConnection.isConnected)
    }
}
