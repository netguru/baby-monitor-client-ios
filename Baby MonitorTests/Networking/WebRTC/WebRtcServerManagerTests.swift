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
        let connectionDelegateProxy = PeerConnectionProxyMock()
        let messageServer = MessageServerMock()
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory,
                                      connectionDelegateProxy: connectionDelegateProxy,
                                      scheduler: AsyncSchedulerMock(),
                                      messageServer: messageServer)

        // When
        sut.start()
        sut.createAnswer(remoteSdp: sdpOffer, completion: { _ in })
        sut.stop()

        // Then
        XCTAssertFalse(peerConnection.isConnected)
    }

    func testShouldAddIceCandidate() {
        // Given
        let sdpOffer = SessionDescriptionMock(sdp: "sdp", stringType: "answer")
        let iceCandidate = IceCandidateMock(sdpMLineIndex: 0, sdpMid: "", sdp: "sdp")
        let peerConnection = PeerConnectionMock()
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection)
        let connectionDelegateProxy = PeerConnectionProxyMock()
        let messageServer = MessageServerMock()
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory,
                                      connectionDelegateProxy: connectionDelegateProxy,
                                      scheduler: AsyncSchedulerMock(),
                                      messageServer: messageServer)

        // When
        sut.start()
        sut.createAnswer(remoteSdp: sdpOffer, completion: { _ in })
        sut.setICECandidates(iceCandidate: iceCandidate)

        // Then
        XCTAssertEqual([iceCandidate], peerConnection.iceCandidates.map { $0 as! IceCandidateMock })
    }

    func testShouldSetOfferWhenCreatingAnswer() {
        // Given
        let sdpOffer = SessionDescriptionMock(sdp: "sdp", stringType: "answer")
        let peerConnection = PeerConnectionMock()
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection)
        let connectionDelegateProxy = PeerConnectionProxyMock()
        let messageServer = MessageServerMock()
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory,
                                      connectionDelegateProxy: connectionDelegateProxy,
                                      scheduler: AsyncSchedulerMock(),
                                      messageServer: messageServer)

        // When
        sut.start()
        sut.createAnswer(remoteSdp: sdpOffer, completion: { _ in })

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
        let videoCapturerMock = VideoCapturerMock()
        let streamId = "test"
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection,
                                                              videoCapturer: videoCapturerMock,
                                                              mediaStream: streamId as MediaStream)
        let connectionDelegateProxy = PeerConnectionProxyMock()
        let messageServer = MessageServerMock()
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory,
                                      connectionDelegateProxy: connectionDelegateProxy,
                                      scheduler: AsyncSchedulerMock(),
                                      messageServer: messageServer)

        sut.mediaStream
            .subscribe(observer)
            .disposed(by: bag)

        // When
        sut.start()
        sut.createAnswer(remoteSdp: sdpOffer, completion: { _ in })

        // Then
        XCTAssertEqual([streamId], observer.events.map { ($0.value.element as! String) })
    }

    func testShouldSendMessageOnCreateAnswerWhenNoStream() {
        // Given
        let sdpOffer = SessionDescriptionMock(sdp: "sdp", stringType: "answer")
        let peerConnection = PeerConnectionMock()
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection)
        let connectionDelegateProxy = PeerConnectionProxyMock()
        let messageServer = MessageServerMock()
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory,
                                      connectionDelegateProxy: connectionDelegateProxy,
                                      scheduler: AsyncSchedulerMock(),
                                      messageServer: messageServer)
        let exp = expectation(description: "Remote SDP answer received.")

        // When
        sut.start()
        sut.createAnswer(remoteSdp: sdpOffer, completion: { _ in
            exp.fulfill()
        })

        // Then
        wait(for: [exp], timeout: 1.0)
        XCTAssertTrue(messageServer.sentMessages.isNotEmpty)
    }

    func testShouldSendMessageOnCreateAnswerWhenError() {
        // Given
        let sdpOffer = SessionDescriptionMock(sdp: "sdp", stringType: "answer")
        let peerConnection = PeerConnectionMock()
        peerConnection.shouldSetRemoteDescriptionFail = true
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection)
        let connectionDelegateProxy = PeerConnectionProxyMock()
        let messageServer = MessageServerMock()
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory,
                                      connectionDelegateProxy: connectionDelegateProxy,
                                      scheduler: AsyncSchedulerMock(),
                                      messageServer: messageServer)
        let exp = expectation(description: "Remote SDP answer received.")

        // When
        sut.start()
        sut.createAnswer(remoteSdp: sdpOffer, completion: { _ in
            exp.fulfill()
        })

        // Then
        wait(for: [exp], timeout: 1.0)
        XCTAssertTrue(messageServer.sentMessages.isNotEmpty)
    }

    func testShouldSetLocalDescriptionOnCreateAnswer() {
        // Given
        let sdpOffer = SessionDescriptionMock(sdp: "sdp", stringType: "answer")
        let peerConnection = PeerConnectionMock(answerSdp: SessionDescriptionMock(sdp: "sdp", stringType: "answer"))
        let videoCapturerMock = VideoCapturerMock()
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection,
                                                              videoCapturer: videoCapturerMock,
                                                              mediaStream: "streamId" as MediaStream)
        let connectionDelegateProxy = PeerConnectionProxyMock()
        let messageServer = MessageServerMock()
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory,
                                      connectionDelegateProxy: connectionDelegateProxy,
                                      scheduler: AsyncSchedulerMock(),
                                      messageServer: messageServer)
        let exp = expectation(description: "Remote SDP answer received.")

        // When
        sut.start()
        sut.createAnswer(remoteSdp: sdpOffer, completion: { _ in
            exp.fulfill()
        })

        // Then
        wait(for: [exp], timeout: 1.0)
        XCTAssertNotNil(peerConnection.localSdp)
    }

    func testShouldNotEmitStreamWhenNoCapturer() {
        // Given
        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(MediaStream.self)
        let peerConnection = PeerConnectionMock()
        let streamId = "test"
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection,
                                                              videoCapturer: nil,
                                                              mediaStream: streamId as MediaStream)
        let connectionDelegateProxy = PeerConnectionProxyMock()
        let messageServer = MessageServerMock()
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory,
                                      connectionDelegateProxy: connectionDelegateProxy,
                                      scheduler: AsyncSchedulerMock(),
                                      messageServer: messageServer)

        sut.mediaStream
            .subscribe(observer)
            .disposed(by: bag)

        // When
        sut.start()

        // Then
        XCTAssertEqual([], observer.events.map { ($0.value.element as! String) })
    }

    func testShouldCaptureStreamAfterStart() {
        // Given
        let videoCapturerMock = VideoCapturerMock()
        let peerConnection = PeerConnectionMock()
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection, videoCapturer: videoCapturerMock)
        let connectionDelegateProxy = PeerConnectionProxyMock()
        let messageServer = MessageServerMock()
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory,
                                      connectionDelegateProxy: connectionDelegateProxy,
                                      scheduler: AsyncSchedulerMock(),
                                      messageServer: messageServer)

        // When
        sut.start()

        // Then
        XCTAssertEqual(videoCapturerMock.isCapturing, true)
    }

    func testShouldStopCaptureOnPause() {
        // Given
        let videoCapturerMock = VideoCapturerMock()
        let peerConnection = PeerConnectionMock()
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection,
                                                              videoCapturer: videoCapturerMock,
                                                              mediaStream: "" as MediaStream)
        let connectionDelegateProxy = PeerConnectionProxyMock()
        let messageServer = MessageServerMock()
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory,
                                      connectionDelegateProxy: connectionDelegateProxy,
                                      scheduler: AsyncSchedulerMock(),
                                      messageServer: messageServer)

        // When
        sut.start()
        sut.pauseMediaStream()

        // Then
        XCTAssertEqual(videoCapturerMock.isCapturing, false)
    }

    func testShouldStartAgainCaptureOnResume() {
        // Given
        let videoCapturerMock = VideoCapturerMock()
        let peerConnection = PeerConnectionMock()
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection,
                                                              videoCapturer: videoCapturerMock,
                                                              mediaStream: "" as MediaStream)
        let connectionDelegateProxy = PeerConnectionProxyMock()
        let messageServer = MessageServerMock()
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory,
                                      connectionDelegateProxy: connectionDelegateProxy,
                                      scheduler: AsyncSchedulerMock(),
                                      messageServer: messageServer)

        // When
        sut.start()
        sut.pauseMediaStream()
        sut.resumeMediaStream()

        // Then
        XCTAssertEqual(videoCapturerMock.isCapturing, true)
    }

    func testShouldEmitStreamOnResume() {
        // Given
        let videoCapturerMock = VideoCapturerMock()
        let peerConnection = PeerConnectionMock()
        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(MediaStream.self)
        let streamId = "test"
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection,
                                                              videoCapturer: videoCapturerMock,
                                                              mediaStream: streamId as MediaStream)
        let connectionDelegateProxy = PeerConnectionProxyMock()
        let messageServer = MessageServerMock()
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory,
                                      connectionDelegateProxy: connectionDelegateProxy,
                                      scheduler: AsyncSchedulerMock(),
                                      messageServer: messageServer)

        sut.mediaStream
            .subscribe(observer)
            .disposed(by: bag)

        // When
        sut.start() // emits stream
        sut.pauseMediaStream()
        sut.resumeMediaStream() // emits stream

        // Then
        XCTAssertEqual([streamId, streamId], observer.events.map { ($0.value.element as! String) })
    }

    func testShouldNotPauseWhenClientIsConnected() {
        // Given
        let videoCapturerMock = VideoCapturerMock()
        let peerConnection = PeerConnectionMock()
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection,
                                                              videoCapturer: videoCapturerMock,
                                                              mediaStream: "" as MediaStream)
        let connectionDelegateProxy = PeerConnectionProxyMock()
        let messageServer = MessageServerMock()
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory,
                                      connectionDelegateProxy: connectionDelegateProxy,
                                      scheduler: AsyncSchedulerMock(),
                                      messageServer: messageServer)

        // When
        sut.start()
        connectionDelegateProxy.simulateConnectionState()
        sut.pauseMediaStream()

        // Then
        XCTAssertEqual(videoCapturerMock.isCapturing, true)
    }

    func testShouldStopCapturingWhenClientDisconnected() {
        // Given
        let videoCapturerMock = VideoCapturerMock()
        let peerConnection = PeerConnectionMock()
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection,
                                                              videoCapturer: videoCapturerMock,
                                                              mediaStream: "" as MediaStream)
        let connectionDelegateProxy = PeerConnectionProxyMock()
        let messageServer = MessageServerMock()
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory,
                                      connectionDelegateProxy: connectionDelegateProxy,
                                      scheduler: AsyncSchedulerMock(),
                                      messageServer: messageServer)

        // When
        sut.start()
        connectionDelegateProxy.simulateDisconnectedState()

        // Then
        XCTAssertEqual(videoCapturerMock.isCapturing, false)
    }

    func testShouldStopCapturingOnStop() {
        // Given
        let videoCapturerMock = VideoCapturerMock()
        let peerConnection = PeerConnectionMock()
        let peerConnectionFactory = PeerConnectionFactoryMock(peerConnectionProtocol: peerConnection,
                                                              videoCapturer: videoCapturerMock,
                                                              mediaStream: "" as MediaStream)
        let connectionDelegateProxy = PeerConnectionProxyMock()
        let messageServer = MessageServerMock()
        let sut = WebRtcServerManager(peerConnectionFactory: peerConnectionFactory,
                                      connectionDelegateProxy: connectionDelegateProxy,
                                      scheduler: AsyncSchedulerMock(),
                                      messageServer: messageServer)

        // When
        sut.start()
        sut.stop()

        // Then
        XCTAssertEqual(videoCapturerMock.isCapturing, false)
    }
}
