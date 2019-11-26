//
//  PeerConnectionFactoryMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import WebRTC

final class PeerConnectionFactoryMock: PeerConnectionFactoryProtocol {

    private let videoCapturer: VideoCapturer?
    private let mediaStream: MediaStream?
    private let peerConnectionProtocol: PeerConnectionProtocol

    init(peerConnectionProtocol: PeerConnectionProtocol,
         videoCapturer: VideoCapturer? = nil,
         mediaStream: MediaStream? = nil) {
        self.mediaStream = mediaStream
        self.videoCapturer = videoCapturer
        self.peerConnectionProtocol = peerConnectionProtocol
    }

    func peerConnection(with delegate: RTCPeerConnectionDelegate) -> PeerConnectionProtocol {
        return peerConnectionProtocol
    }
    
    func createStream() -> (VideoCapturer?, MediaStream?) {
        videoCapturer?.startCapturing()
        return (videoCapturer, mediaStream)
    }
}
