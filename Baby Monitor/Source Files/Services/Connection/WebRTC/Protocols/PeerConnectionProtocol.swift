//
//  PeerConnectionProtocol.swift
//  Baby Monitor
//

import WebRTC

protocol PeerConnectionProtocol {
    func setRemoteDescription(sdp: SessionDescriptionProtocol, completionHandler: ((Error?) -> Void)?)

    func setLocalDescription(sdp: SessionDescriptionProtocol, completionHandler: ((Error?) -> Void)?)

    func add(_ iceCandidate: IceCandidateProtocol)

    func close()

    func createOffer(for constraints: MediaConstraintsProtocol, completionHandler: ((SessionDescriptionProtocol?, Error?) -> Void)?)

    func add(stream: MediaStreamProtocol)
}

extension RTCPeerConnection: PeerConnectionProtocol {

    func add(stream: MediaStreamProtocol) {
        guard let stream = stream as? RTCMediaStream else {
            return
        }
        add(stream)
    }
    
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

    func setRemoteDescription(sdp: SessionDescriptionProtocol, completionHandler: ((Error?) -> Void)?) {
        guard let sdp = sdp as? RTCSessionDescription else {
            return
        }
        setRemoteDescription(sdp, completionHandler: completionHandler)
    }

    func setLocalDescription(sdp: SessionDescriptionProtocol, completionHandler: ((Error?) -> Void)?) {
        guard let sdp = sdp as? RTCSessionDescription else {
            return
        }
        setLocalDescription(sdp, completionHandler: completionHandler)
    }
}
