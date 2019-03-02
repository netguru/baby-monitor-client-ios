//
//  PeerConnectionDelegate.swift
//  Baby Monitor
//

final class RTCPeerConnectionDelegateProxy: NSObject, RTCPeerConnectionDelegate {

    var onSignalingStateChanged: ((RTCPeerConnection, RTCSignalingState) -> Void)?
    var onAddedStream: ((RTCPeerConnection, RTCMediaStream) -> Void)?
    var onGotIceCandidate: ((RTCPeerConnection, RTCICECandidate) -> Void)?

    func peerConnection(_ peerConnection: RTCPeerConnection, signalingStateChanged stateChanged: RTCSignalingState) {
        onSignalingStateChanged?(peerConnection, stateChanged)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, addedStream stream: RTCMediaStream) {
        onAddedStream?(peerConnection, stream)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, gotICECandidate candidate: RTCICECandidate) {
        onGotIceCandidate?(peerConnection, candidate)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, removedStream stream: RTCMediaStream) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, iceConnectionChanged newState: RTCICEConnectionState) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, iceGatheringChanged newState: RTCICEGatheringState) {}
    func peerConnection(onRenegotiationNeeded peerConnection: RTCPeerConnection) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {}

}