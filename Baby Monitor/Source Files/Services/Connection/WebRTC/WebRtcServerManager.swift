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

public class WebRtcServerManager: NSObject {

    var peerConnection: RTCPeerConnection?
    var peerConnectionFactory: RTCPeerConnectionFactory?
    var localSDP: RTCSessionDescription?
    var remoteSDP: RTCSessionDescription?
    public weak var delegate: WebRtcServerManagerDelegate?

    override public init() {
        super.init()
    }
  
    public func addLocalMediaStream() {
        guard let videoSource = peerConnectionFactory?.videoSource(),
            let videoTrack = peerConnectionFactory?.videoTrack(with: videoSource, trackId: WebRtcStreamId.videoTrack.rawValue),
            let localStream = peerConnectionFactory?.mediaStream(withStreamId: WebRtcStreamId.mediaStream.rawValue),
            let audioTrack = peerConnectionFactory?.audioTrack(withTrackId: WebRtcStreamId.audioTrack.rawValue) else {
                return
        }

        localStream.addVideoTrack(videoTrack)
        localStream.addAudioTrack(audioTrack)
        peerConnection?.add(localStream)
        delegate?.localStreamAvailable(stream: localStream)
    }
  
    public func startWebrtcConnection() {
        peerConnectionFactory = RTCPeerConnectionFactory.init()
        peerConnection = peerConnectionFactory?.peerConnection(with: RTCConfiguration(), constraints: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: [WebRtcConstraintKey.dtlsSrtpKeyAgreement.rawValue: "true"]), delegate: self)
    }
  
    public func createConstraints() -> RTCMediaConstraints {
        let peerConnectionConstraints = RTCMediaConstraints(mandatoryConstraints: [WebRtcConstraintKey.offerToReceiveAudio.rawValue: "true", WebRtcConstraintKey.offerToReceiveVideo.rawValue: "true"], optionalConstraints: [WebRtcConstraintKey.dtlsSrtpKeyAgreement.rawValue: "true"])
        return peerConnectionConstraints
    }
  
    public func createAnswer(remoteSDP: RTCSessionDescription) {
        self.remoteSDP = remoteSDP
        addLocalMediaStream()
        peerConnection?.setRemoteDescription(remoteSDP, completionHandler: nil)
    }
  
    public func setICECandidates(iceCandidate: RTCIceCandidate) {
        peerConnection?.add(iceCandidate)
    }

    public func disconnect() {
        peerConnection?.close()
    }
}

extension WebRtcServerManager: RTCPeerConnectionDelegate {
    public func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        self.delegate?.iceCandidatesCreated(iceCandidate: candidate)
    }

    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {}

    public func peerConnection(onRenegotiationNeeded peerConnection: RTCPeerConnection) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didSetSessionDescriptionWithError error: Error?) {
        let answerConstraints = createConstraints()
        peerConnection.answer(for: answerConstraints, completionHandler: { [weak self] sdp, _ in
            guard let sdp = sdp else {
                return
            }
            self?.localSDP = sdp
            peerConnection.setLocalDescription(sdp, completionHandler: nil)
            self?.delegate?.answerSDPCreated(sdp: sdp)
        })
    }

    public func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {}
}
