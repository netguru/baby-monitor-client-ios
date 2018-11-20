//
//  WebrtcManager.swift
//  ConnectedColors
//
//  Created by Mahabali on 4/8/16.
//  Copyright © 2016 Ralf Ebert. All rights reserved.
//

import Foundation
import AVFoundation
import WebRTC

public class WebRtcClientManager: NSObject {

    var peerConnection: RTCPeerConnection?
    var peerConnectionFactory: RTCPeerConnectionFactory?
    var localSdp: RTCSessionDescription?
    var remoteSdp: RTCSessionDescription?

    public weak var delegate: WebRtcClientManagerDelegate?

    override public init() {
        super.init()
        peerConnectionFactory = RTCPeerConnectionFactory()
        peerConnection = peerConnectionFactory?.peerConnection(with: RTCConfiguration(), constraints: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: [WebRtcConstraintKey.dtlsSrtpKeyAgreement.rawValue: "true"]), delegate: self)
    }
  
    public func startWebrtcConnection() {
        self.createOffer()
    }

    public func createOffer() {
        let offerContratints = createConstraints()
        self.peerConnection?.offer(for: offerContratints, completionHandler: { [weak self] sdp, _ in
            guard let sdp = sdp else {
                return
            }
            self?.localSdp = sdp
            self?.peerConnection?.setLocalDescription(sdp, completionHandler: { _ in })
            self?.delegate?.offerSDPCreated(sdp: sdp)
        })
    }
  
    public func createConstraints() -> RTCMediaConstraints {
        let peerConnectionConstraints = RTCMediaConstraints(mandatoryConstraints: [WebRtcConstraintKey.offerToReceiveVideo.rawValue: "true", WebRtcConstraintKey.offerToReceiveAudio.rawValue: "true"], optionalConstraints: [WebRtcConstraintKey.dtlsSrtpKeyAgreement.rawValue: "true"])
        return peerConnectionConstraints
    }
  
    public func setAnswerSDP(sdp: RTCSessionDescription) {
        self.remoteSdp = sdp
        self.peerConnection?.setRemoteDescription(sdp, completionHandler: { _ in })
    }
  
    public func setICECandidates(iceCandidate: RTCIceCandidate) {
        self.peerConnection?.add(iceCandidate)
    }

    public func disconnect() {
        self.peerConnection?.close()
    }
}

extension WebRtcClientManager: RTCPeerConnectionDelegate {
    public func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        delegate?.remoteStreamAvailable(stream: stream)
    }

    public func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        self.delegate?.iceCandidatesCreated(iceCandidate: candidate)
    }

    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {}

    public func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {}

    public func peerConnection(onRenegotiationNeeded peerConnection: RTCPeerConnection) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {}
}
