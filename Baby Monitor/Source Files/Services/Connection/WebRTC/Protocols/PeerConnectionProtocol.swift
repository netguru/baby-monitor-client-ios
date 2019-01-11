//
//  PeerConnectionProtocol.swift
//  Baby Monitor
//

protocol PeerConnectionProtocol {
    func setRemoteDescription(sdp: SessionDescriptionProtocol, delegate: RTCSessionDescriptionDelegate)

    func setLocalDescription(sdp: SessionDescriptionProtocol, delegate: RTCSessionDescriptionDelegate)

    func add(iceCandidate: IceCandidateProtocol)

    func close()

    func createAnswer(for constraints: MediaConstraints, delegate: RTCSessionDescriptionDelegate)

    func createOffer(for constraints: MediaConstraints, delegate: RTCSessionDescriptionDelegate)

    func add(stream: MediaStream)
}

typealias MediaConstraints = AnyObject

extension RTCPeerConnection: PeerConnectionProtocol {

    func add(stream: MediaStream) {
        guard let stream = stream as? RTCMediaStream else {
            return
        }
        add(stream)
    }

    func add(iceCandidate: IceCandidateProtocol) {
        guard let iceCandidate = iceCandidate as? RTCICECandidate else {
            return
        }
        add(iceCandidate)
    }

    func setRemoteDescription(sdp: SessionDescriptionProtocol, delegate: RTCSessionDescriptionDelegate) {
        guard let sdp = sdp as? RTCSessionDescription else {
            return
        }
        setRemoteDescriptionWith(delegate, sessionDescription: sdp)
    }

    func setLocalDescription(sdp: SessionDescriptionProtocol, delegate: RTCSessionDescriptionDelegate) {
        guard let sdp = sdp as? RTCSessionDescription else {
            return
        }
        setLocalDescriptionWith(delegate, sessionDescription: sdp)
    }

    func createAnswer(for constraints: MediaConstraints, delegate: RTCSessionDescriptionDelegate) {
        guard let constraints = constraints as? RTCMediaConstraints else {
            return
        }
        createAnswer(with: delegate, constraints: constraints)
    }

    func createOffer(for constraints: MediaConstraints, delegate: RTCSessionDescriptionDelegate) {
        guard let constraints = constraints as? RTCMediaConstraints else {
            return
        }
        createOffer(with: delegate, constraints: constraints)
    }
}
