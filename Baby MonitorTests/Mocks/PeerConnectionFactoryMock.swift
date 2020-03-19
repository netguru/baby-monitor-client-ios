//
//  PeerConnectionFactoryMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import WebRTC

final class PeerConnectionFactoryMock: PeerConnectionFactoryProtocol {

    private let videoCapturer: VideoCapturer?
    private let mediaStream: WebRTCMediaStream?
    private let peerConnectionProtocol: PeerConnectionProtocol

    init(peerConnectionProtocol: PeerConnectionProtocol,
         videoCapturer: VideoCapturer? = nil,
         mediaStream: WebRTCMediaStream? = nil) {
        self.mediaStream = mediaStream
        self.videoCapturer = videoCapturer
        self.peerConnectionProtocol = peerConnectionProtocol
    }

    func peerConnection(with delegate: PeerConnectionProxy) -> PeerConnectionProtocol {
        return peerConnectionProtocol
    }
    
    func createStream() -> (VideoCapturer?, WebRTCMediaStream?) {
        videoCapturer?.startCapturing()
        return (videoCapturer, mediaStream)
    }

    func createAudioStream() -> WebRTCMediaStream {
        return WebRTCMediaStreamMock()
    }
}
