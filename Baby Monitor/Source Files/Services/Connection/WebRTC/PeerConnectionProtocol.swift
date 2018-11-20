//
//  PeerConnectionProtocol.swift
//  Baby Monitor
//

import WebRTC

protocol PeerConnectionProtocol {
    func setRemoteDescription(_ sdp: SessionDescriptionProtocol, completionHandler: ((Error) -> Void)?)

    func setLocalDescription(_ sdp: SessionDescriptionProtocol, completionHandler: ((Error) -> Void)?)

    func add(_ iceCandidate: IceCandidateProtocol)

    func close()

    func createOffer(for constraints: MediaConstraintsProtocol, completionHandler: ((SessionDescriptionProtocol?, Error?) -> Void)?)
}

extension RTCPeerConnection: PeerConnectionProtocol {

    func createOffer(for constraints: MediaConstraintsProtocol, completionHandler: ((SessionDescriptionProtocol?, Error?) -> Void)?) {
        guard let constraints = constraints as? RTCMediaConstraints else {
            return
        }
        offer(for: constraints) { sdp, error in
            completionHandler?(sdp, error)
        }
    }

    func add(_ iceCandidate: IceCandidateProtocol) {
        guard let iceCandidate = iceCandidate as? RTCIceCandidate else {
            return
        }
        add(iceCandidate)
    }

    func setRemoteDescription(_ sdp: SessionDescriptionProtocol, completionHandler: ((Error) -> Void)?) {
        guard let sdp = sdp as? RTCSessionDescription else {
            return
        }
        setRemoteDescription(sdp, completionHandler: completionHandler)
    }

    func setLocalDescription(_ sdp: SessionDescriptionProtocol, completionHandler: ((Error) -> Void)?) {
        guard let sdp = sdp as? RTCSessionDescription else {
            return
        }
        setLocalDescription(sdp, completionHandler: completionHandler)
    }
}
