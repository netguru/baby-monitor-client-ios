//
//  PeerConnectionFactoryMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

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
    func createStream(handler: (MediaStream, VideoCapturer) -> Void) {
        guard let mediaStream = mediaStream else { return }
        handler(mediaStream, mediaStream)
    }
}
