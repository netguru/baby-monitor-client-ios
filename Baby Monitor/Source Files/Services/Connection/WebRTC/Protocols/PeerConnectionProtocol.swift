//
//  PeerConnectionProtocol.swift
//  Baby Monitor
//

import WebRTC

protocol PeerConnectionProtocol {
    func setRemoteDescription(sdp: SessionDescriptionProtocol, handler: ((Error?) -> Void)?)

    func setLocalDescription(sdp: SessionDescriptionProtocol, handler: ((Error?) -> Void)?)

    func close()

    func createAnswer(for constraints: MediaConstraints, handler: ((RTCSessionDescription?, Error?) -> Void)?)

    func createOffer(for constraints: MediaConstraints, handler: ((RTCSessionDescription?, Error?) -> Void)?)

    func add(stream: MediaStream)
}

typealias MediaConstraints = AnyObject
typealias MediaStream = AnyObject

extension RTCPeerConnection: PeerConnectionProtocol {

    func add(stream: MediaStream) {
        guard let stream = stream as? RTCMediaStream else {
            return
        }
        add(stream)
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
