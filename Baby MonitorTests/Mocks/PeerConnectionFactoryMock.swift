//
//  PeerConnectionFactoryMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import WebRTC

struct VideoCapturerMock: VideoCapturer {
    func resumeCapturing() {}
    func stopCapturing() {}
}

final class PeerConnectionFactoryMock: PeerConnectionFactoryProtocol {

    private let mediaStream: MediaStream?
    private let peerConnectionProtocol: PeerConnectionProtocol

    init(peerConnectionProtocol: PeerConnectionProtocol, mediaStream: MediaStream? = nil) {
        self.mediaStream = mediaStream
        self.peerConnectionProtocol = peerConnectionProtocol
    }

    func peerConnection(with delegate: RTCPeerConnectionDelegate) -> PeerConnectionProtocol {
        return peerConnectionProtocol
    }
    
    func createStream() -> (VideoCapturer?, MediaStream?) {
        return (VideoCapturerMock(), mediaStream)
    }
}
