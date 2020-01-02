//
//  PeerConnectionProxyMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import WebRTC
import RxSwift

final class PeerConnectionProxyMock: NSObject, PeerConnectionProxy {

    var signalingState: Observable<RTCSignalingState> { return signalingStatePublisher }

    private var signalingStatePublisher = BehaviorSubject<RTCSignalingState>(value: .closed)

    var onSignalingStateChanged: ((RTCPeerConnection, RTCSignalingState) -> Void)?

    var onConnectionStateChanged: ((RTCPeerConnection?, RTCPeerConnectionState) -> Void)?

    var onAddedStream: ((RTCPeerConnection, RTCMediaStream) -> Void)?

    var onGotIceCandidate: ((RTCPeerConnection, RTCIceCandidate) -> Void)?

    func simulateConnectionState() {
        onConnectionStateChanged?(nil, RTCPeerConnectionState.connected)
    }

    func simulateDisconnectedState() {
        onConnectionStateChanged?(nil, RTCPeerConnectionState.disconnected)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {}

    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {}

    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {}

    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {}

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {}

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {}

    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {}

    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {}

    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {}
}
