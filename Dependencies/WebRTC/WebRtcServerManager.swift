//
//  WebrtcManager.swift
//  ConnectedColors
//
//  Created by Mahabali on 4/8/16.
//  Copyright © 2016 Ralf Ebert. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift

public class WebRtcServerManager: NSObject, RTCPeerConnectionDelegate, RTCSessionDescriptionDelegate, WebRtcServerManagerProtocol {

    var localStream: RTCMediaStream?
    var peerConnection: RTCPeerConnection?
    var peerConnectionFactory: RTCPeerConnectionFactory?
    var videoCapturer: RTCVideoCapturer?
    var localAudioTrack: RTCAudioTrack?
    var localVideoTrack: RTCVideoTrack?
    var localSDP: RTCSessionDescription?
    var remoteSDP: RTCSessionDescription?
    var sdpAnswer: Observable<RTCSessionDescription> {
        return sdpAnswerPublisher
    }
    var iceCandidate: Observable<RTCICECandidate> {
        return iceCandidatePublisher
    }
    var mediaStream: Observable<RTCMediaStream> {
        return mediaStreamPublisher
    }
    
    let mediaStreamPublisher = PublishSubject<RTCMediaStream>()
    let sdpAnswerPublisher = PublishSubject<RTCSessionDescription>()
    let iceCandidatePublisher = PublishSubject<RTCICECandidate>()
    
    override public init() {
        super.init()
        peerConnectionFactory = RTCPeerConnectionFactory.init()
        peerConnection = peerConnectionFactory?.peerConnection(withICEServers: [], constraints: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: [RTCPair(key: "DtlsSrtpKeyAgreement", value: "true")]), delegate: self)
    }
    
    func start() {
        addLocalMediaStream()
    }
    
    public func addLocalMediaStream() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) else {
            return
        }
        let cameraID = device.localizedName
        let videoCapturer = RTCVideoCapturer(deviceName: cameraID)
        self.videoCapturer = videoCapturer
        let videoSource = peerConnectionFactory?.videoSource(with: videoCapturer, constraints: nil)
        let videoTrack = peerConnectionFactory?.videoTrack(withID: "ARDAMSv0", source: videoSource)
        localStream = peerConnectionFactory?.mediaStream(withLabel: "ARDAMS")
        let audioTrack = peerConnectionFactory?.audioTrack(withID: "ARDAMSa0")
        localAudioTrack = audioTrack
        localVideoTrack = videoTrack
        localStream?.addVideoTrack(videoTrack)
        localStream?.addAudioTrack(audioTrack)
        DispatchQueue.main.async {}
        mediaStreamPublisher.onNext(localStream!)
        self.peerConnection?.add(localStream!)
    }
    
    public func startWebrtcConnection() {
        peerConnectionFactory = RTCPeerConnectionFactory.init()
        peerConnection = peerConnectionFactory?.peerConnection(withICEServers: [], constraints: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: [RTCPair(key: "DtlsSrtpKeyAgreement", value: "true")]), delegate: self)
    }
    
    public func createConstraints() -> RTCMediaConstraints {
        let pairOfferToReceiveAudio = RTCPair(key: "OfferToReceiveAudio", value: "true")!
        let pairOfferToReceiveVideo = RTCPair(key: "OfferToReceiveVideo", value: "true")!
        let pairDtlsSrtpKeyAgreement = RTCPair(key: "DtlsSrtpKeyAgreement", value: "true")!
        let peerConnectionConstraints = RTCMediaConstraints(mandatoryConstraints: [pairOfferToReceiveVideo, pairOfferToReceiveAudio], optionalConstraints: [pairDtlsSrtpKeyAgreement])
        return peerConnectionConstraints!
    }
    
    func createAnswer(remoteSdp remoteSDP: RTCSessionDescription) {
        DispatchQueue.main.async {
            self.remoteSDP = remoteSDP
            self.peerConnection!.setRemoteDescriptionWith(self, sessionDescription: remoteSDP)
        }
    }
    
    public func setICECandidates(iceCandidate: RTCICECandidate) {
        DispatchQueue.main.async {
            self.peerConnection?.add(iceCandidate)
        }
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, addedStream stream: RTCMediaStream) {}
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, gotICECandidate candidate: RTCICECandidate) {
        iceCandidatePublisher.onNext(candidate)
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, iceConnectionChanged newState: RTCICEConnectionState) {}
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, iceGatheringChanged newState: RTCICEGatheringState) {}
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, removedStream stream: RTCMediaStream) {}
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, signalingStateChanged stateChanged: RTCSignalingState) {}
    
    public func peerConnection(onRenegotiationNeeded peerConnection: RTCPeerConnection) {}
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {}
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didCreateSessionDescription sdp: RTCSessionDescription, error: Error?) {
        self.localSDP = sdp
        self.peerConnection?.setLocalDescriptionWith(self, sessionDescription: sdp)
        sdpAnswerPublisher.onNext(sdp)
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didSetSessionDescriptionWithError error: Error?) {
        if self.localSDP == nil {
            let answerConstraints = self.createConstraints()
            self.peerConnection!.createAnswer(with: self, constraints: answerConstraints)
        }
    }

    public func channel(channel: RTCDataChannel, didReceiveMessageWithBuffer buffer: RTCDataBuffer) {}
    
    public func disconnect() {
        self.peerConnection?.close()
    }
}
