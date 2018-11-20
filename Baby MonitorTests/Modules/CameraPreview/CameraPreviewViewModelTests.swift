//
//  CameraPreviewViewModelTests.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import XCTest
import RxSwift
import RxTest

class CameraPreviewViewModelTests: XCTestCase {

    func testShouldOpenSocketOnPlay() {
        // Given
        let webRtcClientManager = WebRtcClientManagerMock()
        let webSocket = WebSocketMock()
        let babyRepo = BabiesRepositoryMock()
        let decoders = [AnyMessageDecoder<WebRtcMessage>(IceCandidateDecoder())]
        let sut = CameraPreviewViewModel(webRtcClientManager: webRtcClientManager, webSocket: webSocket, babyRepo: babyRepo, decoders: decoders)

        // When
        sut.play()

        // Then
        XCTAssertTrue(webSocket.isOpen)
    }

    func testShouldSendIceCandidate() {
        // Given
        let webRtcClientManager = WebRtcClientManagerMock()
        let webSocket = WebSocketMock()
        let babyRepo = BabiesRepositoryMock()
        let iceCandidate = IceCandidateMock(sdpMLineIndex: Int32(0), sdpMid: "", sdp: "sdp")
        let decoders = [AnyMessageDecoder<WebRtcMessage>(IceCandidateDecoder())]
        let sut = CameraPreviewViewModel(webRtcClientManager: webRtcClientManager, webSocket: webSocket, babyRepo: babyRepo, decoders: decoders)

        // When
        sut.play()
        webRtcClientManager.iceCandidatePublisher.onNext(iceCandidate)

        // Then
        XCTAssertEqual([[WebRtcMessage.Key.iceCandidate.rawValue: iceCandidate.jsonDictionary()].jsonString], webSocket.sentMessages.map { $0 as! String })
    }

    func testShouldSendSdpOffer() {
        // Given
        let sdpOffer = SessionDescriptionMock(sdp: "sdp", stringType: "type")
        let webRtcClientManager = WebRtcClientManagerMock(sdpOffer: sdpOffer)
        let webSocket = WebSocketMock()
        let babyRepo = BabiesRepositoryMock()
        let decoders = [AnyMessageDecoder<WebRtcMessage>(IceCandidateDecoder())]
        let sut = CameraPreviewViewModel(webRtcClientManager: webRtcClientManager, webSocket: webSocket, babyRepo: babyRepo, decoders: decoders)

        // When
        sut.play()

        // Then
        XCTAssertEqual([[WebRtcMessage.Key.offerSDP.rawValue: sdpOffer.jsonDictionary()].jsonString], webSocket.sentMessages.map { $0 as! String })
    }

    func testShouldDispatchIceCandidate() {
        // Given
        let iceCandidate = IceCandidateMock(sdpMLineIndex: Int32(0), sdpMid: "", sdp: "sdp")
        let webRtcClientManager = WebRtcClientManagerMock()
        let webSocket = WebSocketMock()
        let babyRepo = BabiesRepositoryMock()
        let decoders = [AnyMessageDecoder<WebRtcMessage>(IceCandidateDecoderMock(iceCandidate: iceCandidate))]
        let sut = CameraPreviewViewModel(webRtcClientManager: webRtcClientManager, webSocket: webSocket, babyRepo: babyRepo, decoders: decoders)

        // When
        sut.play()
        webSocket.receivedMessagePublisher.onNext("test")

        // Then
        XCTAssertEqual([iceCandidate], webRtcClientManager.iceCandidates as! [IceCandidateMock])
    }

    func testShouldDispatchSdpAnswer() {
        // Given
        let sdpAnswer = SessionDescriptionMock(sdp: "sdp", stringType: "type")
        let webRtcClientManager = WebRtcClientManagerMock()
        let webSocket = WebSocketMock()
        let babyRepo = BabiesRepositoryMock()
        let decoders = [AnyMessageDecoder<WebRtcMessage>(SdpAnswerDecoderMock(sdpAnswer: sdpAnswer))]
        let sut = CameraPreviewViewModel(webRtcClientManager: webRtcClientManager, webSocket: webSocket, babyRepo: babyRepo, decoders: decoders)

        // When
        sut.play()
        webSocket.receivedMessagePublisher.onNext("test")

        // Then
        XCTAssertEqual(sdpAnswer, webRtcClientManager.remoteSdp! as! SessionDescriptionMock)
    }

}
