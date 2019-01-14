//
//  SessionDescriptionDelegate.swift
//  Baby Monitor
//

protocol SessionDescriptionDelegate: AnyObject {
    func didSetDescription()
    func didCreateDescription(_ sdp: SessionDescriptionProtocol)
}

final class SessionDescriptionDelegateProxy: NSObject, RTCSessionDescriptionDelegate {

    weak var delegate: SessionDescriptionDelegate?

    func peerConnection(_ peerConnection: RTCPeerConnection, didCreateSessionDescription sdp: RTCSessionDescription, error: Error) {
        delegate?.didCreateDescription(sdp)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didSetSessionDescriptionWithError error: Error) {
        delegate?.didSetDescription()
    }
}
