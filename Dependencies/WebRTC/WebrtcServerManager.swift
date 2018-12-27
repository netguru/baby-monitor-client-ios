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

public class WebrtcServerManager: NSObject, RTCPeerConnectionDelegate, RTCSessionDescriptionDelegate, WebRtcServerManagerProtocol {
    var sdpAnswer: Observable<RTCSessionDescription> {
        return sdpAnswerPublisher
    }
    let sdpAnswerPublisher = PublishSubject<RTCSessionDescription>()
    
    var iceCandidate: Observable<RTCICECandidate> {
        return iceCandidatePublisher
    }
    let iceCandidatePublisher = PublishSubject<RTCICECandidate>()
    
    var mediaStream: Observable<RTCMediaStream> {
        return mediaStreamPublisher
    }
    let mediaStreamPublisher = PublishSubject<RTCMediaStream>()
    
    func start() {
        
    }
    
  var peerConnection: RTCPeerConnection?
  var peerConnectionFactory: RTCPeerConnectionFactory?
  var videoCapturer: RTCVideoCapturer?
  var localAudioTrack: RTCAudioTrack?
  var localVideoTrack: RTCVideoTrack?
  var localSDP: RTCSessionDescription?
  var remoteSDP: RTCSessionDescription?
  public weak var delegate: WebrtcServerManagerDelegate?
  var localStream: RTCMediaStream?
  var unusedICECandidates: [RTCICECandidate] = []
  var initiator = false
    private let debug = true
  
  override public init() {
    super.init()
    peerConnectionFactory = RTCPeerConnectionFactory.init()
    peerConnection = peerConnectionFactory?.peerConnection(withICEServers: [], constraints: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: [RTCPair(key: "DtlsSrtpKeyAgreement", value: "true")]), delegate: self)
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
    DispatchQueue.main.async {

    }
    mediaStreamPublisher.onNext(localStream!)
    self.peerConnection?.add(localStream!)
  }
  
  public func startWebrtcConnection() {
    peerConnectionFactory = RTCPeerConnectionFactory.init()
    peerConnection = peerConnectionFactory?.peerConnection(withICEServers: [], constraints: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: [RTCPair(key: "DtlsSrtpKeyAgreement", value: "true")]), delegate: self)
      self.waitForAnswer()
  }
  
  public func createConstraints() -> RTCMediaConstraints {
    let pairOfferToReceiveAudio = RTCPair(key: "OfferToReceiveAudio", value: "true")!
    let pairOfferToReceiveVideo = RTCPair(key: "OfferToReceiveVideo", value: "true")!
    let pairDtlsSrtpKeyAgreement = RTCPair(key: "DtlsSrtpKeyAgreement", value: "true")!
    let peerConnectionConstraints = RTCMediaConstraints(mandatoryConstraints: [pairOfferToReceiveVideo, pairOfferToReceiveAudio], optionalConstraints: [pairDtlsSrtpKeyAgreement])
    return peerConnectionConstraints!
  }
  
  public func waitForAnswer() {
    
    }
  
    public func createAnswer(remoteSdp remoteSDP: RTCSessionDescription) {
    DispatchQueue.main.async {
      self.remoteSDP = remoteSDP
      self.addLocalMediaStream()
        self.peerConnection!.setRemoteDescriptionWith(self, sessionDescription: remoteSDP)
    }
      }
  
  public func setICECandidates(iceCandidate: RTCICECandidate) {
    DispatchQueue.main.async {
        self.peerConnection?.add(iceCandidate)
    }
  }
  
  public func addUnusedIceCandidates() {
    for (iceCandidate) in self.unusedICECandidates {
      print("added unused ices")
        self.peerConnection?.add(iceCandidate)
    }
    self.unusedICECandidates = []
  }
    public func peerConnection(_ peerConnection: RTCPeerConnection, addedStream stream: RTCMediaStream) {
    print("Log: PEER CONNECTION:- Stream Added")
  }
  
    public func peerConnection(_ peerConnection: RTCPeerConnection, gotICECandidate candidate: RTCICECandidate) {
    print("PEER CONNECTION:- Got ICE Candidate - \(candidate)")
        iceCandidatePublisher.onNext(candidate)
 
  }
    public func peerConnection(_ peerConnection: RTCPeerConnection, iceConnectionChanged newState: RTCICEConnectionState) {
    print("PEER CONNECTION:- ICE Connection Changed \(newState)")
  }
    public func peerConnection(_ peerConnection: RTCPeerConnection, iceGatheringChanged newState: RTCICEGatheringState) {
    print("PEER CONNECTION:- ICE Gathering Changed - \(newState)")
  
  }
    public func peerConnection(_ peerConnection: RTCPeerConnection, removedStream stream: RTCMediaStream) {
    print("PEER CONNECTION:- Stream Removed")
  }
    public func peerConnection(_ peerConnection: RTCPeerConnection, signalingStateChanged stateChanged: RTCSignalingState) {
    print("PEER CONNECTION:- Signaling State Changed \(stateChanged)")
  }
    public func peerConnection(onRenegotiationNeeded peerConnection: RTCPeerConnection) {
    print("PEER CONNECTION:- Renegotiation Needed")
  }
  
    public func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
    print("PEER CONNECTION:- Open Data Channel")
  }

    public func peerConnection(_ peerConnection: RTCPeerConnection, didCreateSessionDescription sdp: RTCSessionDescription, error: Error?) {
    if let er = error {
      print(er.localizedDescription)
    }
    self.localSDP = sdp
        self.peerConnection?.setLocalDescriptionWith(self, sessionDescription: sdp)
        sdpAnswerPublisher.onNext(sdp)
  }
  
    public func peerConnection(_ peerConnection: RTCPeerConnection, didSetSessionDescriptionWithError error: Error?) {
      print("SDP set success")
      if initiator == false && self.localSDP == nil {
      
        let answerConstraints = self.createConstraints()
        self.peerConnection!.createAnswer(with: self, constraints: answerConstraints)
      }
  }
  
  // Called when the data channel state has changed.
  public func channelDidChangeState(channel: RTCDataChannel) {

  }
  
  public func channel(channel: RTCDataChannel, didReceiveMessageWithBuffer buffer: RTCDataBuffer) {
    self.delegate?.dataReceivedInChannel(data: buffer.data! as NSData)
  }
    
  public func disconnect() {
    self.peerConnection?.close()
  }
}
