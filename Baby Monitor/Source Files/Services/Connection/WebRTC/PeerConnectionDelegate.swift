//
//  PeerConnectionDelegate.swift
//  Baby Monitor
//

protocol PeerConnectionDelegate: AnyObject {
    func addedStream(_ stream: MediaStream)
    func gotIceCandidate(_ iceCandidate: IceCandidateProtocol)
}

typealias MediaStream = AnyObject

final class PeerConnectionDelegateProxy: NSObject, RTCPeerConnectionDelegate {

    weak var delegate: PeerConnectionDelegate?

    func peerConnection(_ peerConnection: RTCPeerConnection, signalingStateChanged stateChanged: RTCSignalingState) {}

    // TODO: 🐞 This method not beeing called is the reason, why video is not showing up on parent.
    // This bug happens on ios 11, and also on any system on going to preview screen right after making a connection for the first time.
    func peerConnection(_ peerConnection: RTCPeerConnection, addedStream stream: RTCMediaStream) {
        delegate?.addedStream(stream)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, removedStream stream: RTCMediaStream) {}

    func peerConnection(onRenegotiationNeeded peerConnection: RTCPeerConnection) {}

    func peerConnection(_ peerConnection: RTCPeerConnection, iceConnectionChanged newState: RTCICEConnectionState) {}

    func peerConnection(_ peerConnection: RTCPeerConnection, iceGatheringChanged newState: RTCICEGatheringState) {}

    func peerConnection(_ peerConnection: RTCPeerConnection, gotICECandidate candidate: RTCICECandidate) {
        delegate?.gotIceCandidate(candidate)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {}
}
