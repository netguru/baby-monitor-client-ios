//
//  PeerConnectionDelegate.swift
//  Baby Monitor
//

import RxSwift
import WebRTC

final class RTCPeerConnectionDelegateProxy: NSObject, RTCPeerConnectionDelegate {

    var signalingState: Observable<RTCSignalingState> { return signalingStatePublisher }
    private var signalingStatePublisher = BehaviorSubject<RTCSignalingState>(value: .closed)

    var onSignalingStateChanged: ((RTCPeerConnection, RTCSignalingState) -> Void)?
    var onAddedStream: ((RTCPeerConnection, RTCMediaStream) -> Void)?

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCSignalingState) {
        onSignalingStateChanged?(peerConnection, newState)
        signalingStatePublisher.onNext(newState)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        onAddedStream?(peerConnection, stream)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {}

    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {}
    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {}
}
