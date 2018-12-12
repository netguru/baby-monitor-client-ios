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
        let sut = WebRtcClientManager(peerConnection: peerConnection)

        // When
        sut.sdpOffer
            .subscribe(observer)
            .disposed(by: bag)
        scheduler.start()
        sut.startWebRtcConnection()

        // Then
        XCTAssertEqual(observer.events.map { $0.value.element! as! SessionDescriptionMock }, [offerSdp])
    }

    func testShouldSetAnswer() {
        // Given
        let answerSdp = SessionDescriptionMock(sdp: "sdp", stringType: "type")
        let peerConnection = PeerConnectionMock()
        let sut = WebRtcClientManager(peerConnection: peerConnection)

        // When
        sut.setAnswerSDP(sdp: answerSdp)

        // Then
        XCTAssertEqual(answerSdp, peerConnection.remoteSdp as! SessionDescriptionMock)
    }

    func testShouldAddIceCandidate() {
        // Given
        let iceCandidate = IceCandidateMock(sdpMLineIndex: Int32(0), sdpMid: "", sdp: "sdp")
        let peerConnection = PeerConnectionMock()
        let sut = WebRtcClientManager(peerConnection: peerConnection)

        // When
        sut.setICECandidates(iceCandidate: iceCandidate)

        // Then
        XCTAssertEqual([iceCandidate], peerConnection.iceCandidates as! [IceCandidateMock])
    }

    func testShouldAddMultipleIceCandidate() {
        // Given
        let iceCandidate = IceCandidateMock(sdpMLineIndex: Int32(0), sdpMid: "", sdp: "sdp")
        let secondIceCandidate = IceCandidateMock(sdpMLineIndex: Int32(0), sdpMid: "", sdp: "sdp2")
        let peerConnection = PeerConnectionMock()
        let sut = WebRtcClientManager(peerConnection: peerConnection)

        // When
        sut.setICECandidates(iceCandidate: iceCandidate)
        sut.setICECandidates(iceCandidate: secondIceCandidate)

        // Then
        XCTAssertEqual([iceCandidate, secondIceCandidate], peerConnection.iceCandidates as! [IceCandidateMock])
    }

    func testShouldDisconnect() {
        // Given
        let peerConnection = PeerConnectionMock()
        let sut = WebRtcClientManager(peerConnection: peerConnection)

        // When
        sut.disconnect()

        // Then
        XCTAssertFalse(peerConnection.isConnected)
    }
}
