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

    private var peerConnection: RTCPeerConnection?
    private let peerConnectionFactory: RTCPeerConnectionFactory?
    private var localSdp: RTCSessionDescription?
    private var remoteSdp: RTCSessionDescription?

    weak var delegate: WebRtcClientManagerDelegate?

    override public init() {
        peerConnectionFactory = RTCPeerConnectionFactory()
        super.init()
        peerConnection = peerConnectionFactory?.peerConnection(with: RTCConfiguration(), constraints: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: [WebRtcConstraintKey.dtlsSrtpKeyAgreement.rawValue: "true"]), delegate: self)
    }
  
    func startWebrtcConnection() {
        createOffer()
    }

    private func createOffer() {
        let offerContratints = createConstraints()
        peerConnection?.offer(for: offerContratints, completionHandler: { [weak self] sdp, _ in
            guard let sdp = sdp else {
                return
            }
            self?.localSdp = sdp
            self?.peerConnection?.setLocalDescription(sdp, completionHandler: { _ in })
            self?.delegate?.offerSDPCreated(sdp: sdp)
        })
    }
  
    private func createConstraints() -> RTCMediaConstraints {
        let peerConnectionConstraints = RTCMediaConstraints(mandatoryConstraints: [WebRtcConstraintKey.offerToReceiveVideo.rawValue: "true", WebRtcConstraintKey.offerToReceiveAudio.rawValue: "true"], optionalConstraints: [WebRtcConstraintKey.dtlsSrtpKeyAgreement.rawValue: "true"])
        return peerConnectionConstraints
    }
  
    func setAnswerSDP(sdp: RTCSessionDescription) {
        remoteSdp = sdp
        peerConnection?.setRemoteDescription(sdp, completionHandler: { _ in })
    }
  
    func setICECandidates(iceCandidate: RTCIceCandidate) {
        peerConnection?.add(iceCandidate)
    }

    func disconnect() {
        peerConnection?.close()
    }
}

extension WebRtcClientManager: RTCPeerConnectionDelegate {
    public func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        delegate?.remoteStreamAvailable(stream: stream)
    }

    public func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        delegate?.iceCandidatesCreated(iceCandidate: candidate)
    }

    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {}

    public func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {}

    public func peerConnection(onRenegotiationNeeded peerConnection: RTCPeerConnection) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {}
}
