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

    private(set) weak var delegate: PeerConnectionDelegate?

    init(delegate: PeerConnectionDelegate) {
        self.delegate = delegate
    }

    func peerConnection(_ peerConnection: RTCPeerConnection!, signalingStateChanged stateChanged: RTCSignalingState) {}

    func peerConnection(_ peerConnection: RTCPeerConnection!, addedStream stream: RTCMediaStream!) {
        delegate?.addedStream(stream)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection!, removedStream stream: RTCMediaStream!) {}

    func peerConnection(onRenegotiationNeeded peerConnection: RTCPeerConnection!) {}

    func peerConnection(_ peerConnection: RTCPeerConnection!, iceConnectionChanged newState: RTCICEConnectionState) {}

    func peerConnection(_ peerConnection: RTCPeerConnection!, iceGatheringChanged newState: RTCICEGatheringState) {}

    func peerConnection(_ peerConnection: RTCPeerConnection!, gotICECandidate candidate: RTCICECandidate!) {
        delegate?.gotIceCandidate(candidate)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection!, didOpen dataChannel: RTCDataChannel!) {}
}
