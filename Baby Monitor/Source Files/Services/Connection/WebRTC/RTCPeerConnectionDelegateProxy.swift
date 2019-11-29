//
//  PeerConnectionDelegate.swift
//  Baby Monitor
//

import RxSwift
import WebRTC

protocol PeerConnectionProxy: RTCPeerConnectionDelegate {
    var signalingState: Observable<RTCSignalingState> { get }
    var onSignalingStateChanged: ((RTCPeerConnection, RTCSignalingState) -> Void)? { get set }
    var onConnectionStateChanged: ((RTCPeerConnection?, RTCPeerConnectionState) -> Void)? { get set }
    var onAddedStream: ((RTCPeerConnection, RTCMediaStream) -> Void)? { get set }
    var onGotIceCandidate: ((RTCPeerConnection, RTCIceCandidate) -> Void)? { get set }
}

final class RTCPeerConnectionDelegateProxy: NSObject, PeerConnectionProxy {

    var signalingState: Observable<RTCSignalingState> { return signalingStatePublisher }
    private var signalingStatePublisher = PublishSubject<RTCSignalingState>()

    var onSignalingStateChanged: ((RTCPeerConnection, RTCSignalingState) -> Void)?
    var onConnectionStateChanged: ((RTCPeerConnection?, RTCPeerConnectionState) -> Void)?
    var onAddedStream: ((RTCPeerConnection, RTCMediaStream) -> Void)?
    var onGotIceCandidate: ((RTCPeerConnection, RTCIceCandidate) -> Void)?

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCSignalingState) {
        onSignalingStateChanged?(peerConnection, newState)
        signalingStatePublisher.onNext(newState)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCPeerConnectionState) {
        onConnectionStateChanged?(peerConnection, newState)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        onAddedStream?(peerConnection, stream)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        onGotIceCandidate?(peerConnection, candidate)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {}
    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {}
}
