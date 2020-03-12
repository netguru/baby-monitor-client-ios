//
//  PeerConnectionProtocol.swift
//  Baby Monitor
//

import WebRTC

protocol PeerConnectionProtocol {
    func setRemoteDescription(sdp: SessionDescriptionProtocol, handler: ((Error?) -> Void)?)

    func setLocalDescription(sdp: SessionDescriptionProtocol, handler: ((Error?) -> Void)?)

    func add(iceCandidate: IceCandidateProtocol)

    func close()

    func createAnswer(for constraints: MediaConstraints, handler: ((RTCSessionDescription?, Error?) -> Void)?)

    func createOffer(for constraints: MediaConstraints, handler: ((RTCSessionDescription?, Error?) -> Void)?)

    func add(stream: MediaStream)
}

typealias MediaConstraints = AnyObject
typealias MediaStream = AnyObject

extension RTCPeerConnection: PeerConnectionProtocol {

    func add(stream: MediaStream) {
        guard let stream = stream as? RTCMediaStream,
            let audioTrack = stream.audioTracks.first else {
            return
        }
        add(audioTrack, streamIds: [stream.streamId])
        if let videoTrack = stream.videoTracks.first {
            add(videoTrack, streamIds: [stream.streamId])
        }
    }

    func add(iceCandidate: IceCandidateProtocol) {
        guard let iceCandidate = iceCandidate as? RTCIceCandidate else {
            return
        }
        add(iceCandidate)
    }

    func setRemoteDescription(sdp: SessionDescriptionProtocol, handler: ((Error?) -> Void)?) {
        guard let sdp = sdp as? RTCSessionDescription else {
            return
        }
        setRemoteDescription(sdp, completionHandler: handler)
    }

    func setLocalDescription(sdp: SessionDescriptionProtocol, handler: ((Error?) -> Void)?) {
        guard let sdp = sdp as? RTCSessionDescription else {
            return
        }
        setLocalDescription(sdp, completionHandler: handler)
    }

    func createAnswer(for constraints: MediaConstraints, handler: ((RTCSessionDescription?, Error?) -> Void)?) {
        guard let constraints = constraints as? RTCMediaConstraints else {
            return
        }
        answer(for: constraints, completionHandler: handler)
    }

    func createOffer(for constraints: MediaConstraints, handler: ((RTCSessionDescription?, Error?) -> Void)?) {
        guard let constraints = constraints as? RTCMediaConstraints else {
            return
        }
        offer(for: constraints, completionHandler: handler)
    }
}
