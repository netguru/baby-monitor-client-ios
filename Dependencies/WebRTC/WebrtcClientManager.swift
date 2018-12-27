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
public class WebrtcClientManager: NSObject, RTCPeerConnectionDelegate, RTCSessionDescriptionDelegate, WebRtcClientManagerProtocol {
    
    var sdpOffer: Observable<RTCSessionDescription> {
        return sdpOfferPublisher
    }
    let sdpOfferPublisher = PublishSubject<RTCSessionDescription>()
    
    var iceCandidate: Observable<RTCICECandidate> {
        return iceCandidatePublisher
    }
    let iceCandidatePublisher = PublishSubject<RTCICECandidate>()
    
    var mediaStream: Observable<RTCMediaStream> {
        return mediaStreamPublisher
    }
    let mediaStreamPublisher = PublishSubject<RTCMediaStream>()
    
    
  var peerConnection: RTCPeerConnection?
  var peerConnectionFactory: RTCPeerConnectionFactory?
  var videoCapturer: RTCVideoCapturer?
  var localAudioTrack: RTCAudioTrack?
  var localVideoTrack: RTCVideoTrack?
  var localSDP: RTCSessionDescription?
  var remoteSDP: RTCSessionDescription?
  public weak var delegate: WebrtcClientManagerDelegate?
  var localStream: RTCMediaStream?
  var unusedICECandidates: [RTCICECandidate] = []
  var initiator = false
  
  override public init() {
    super.init()
  }
  
  public func startWebRtcConnection() {
    peerConnectionFactory = RTCPeerConnectionFactory()
    peerConnection = peerConnectionFactory?.peerConnection(withICEServers: [], constraints: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: [RTCPair(key: "DtlsSrtpKeyAgreement", value: "true")]), delegate: self)
      self.createOffer()
  }
  
  public func createOffer() {
    let offerContratints = createConstraints()
    self.peerConnection?.createOffer(with: self, constraints: offerContratints)
  }
  
  public func createConstraints() -> RTCMediaConstraints {
    let pairOfferToReceiveAudio = RTCPair(key: "OfferToReceiveAudio", value: "true")!
    let pairOfferToReceiveVideo = RTCPair(key: "OfferToReceiveVideo", value: "true")!
    let pairDtlsSrtpKeyAgreement = RTCPair(key: "DtlsSrtpKeyAgreement", value: "true")!
    let peerConnectionConstraints = RTCMediaConstraints(mandatoryConstraints: [pairOfferToReceiveVideo, pairOfferToReceiveAudio], optionalConstraints: [pairDtlsSrtpKeyAgreement])
    return peerConnectionConstraints!
  }
  
    public func setAnswerSDP(sdp: RTCSessionDescription) {
    DispatchQueue.main.async {
        self.remoteSDP = sdp
        self.peerConnection?.setRemoteDescriptionWith(self, sessionDescription: self.remoteSDP)
      self.addUnusedIceCandidates()
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
        mediaStreamPublisher.onNext(stream)
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
        sdpOfferPublisher.onNext(sdp)
  }
  
    public func peerConnection(_ peerConnection: RTCPeerConnection, didSetSessionDescriptionWithError error: Error?) {
    if error != nil {
        print("sdp error \(String(describing: error?.localizedDescription)) \(String(describing: error))")
    }
  }
  
  // Called when the data channel state has changed.
  func channelDidChangeState(channel: RTCDataChannel) {

  }
  
  public func channel(channel: RTCDataChannel, didReceiveMessageWithBuffer buffer: RTCDataBuffer) {
    self.delegate?.dataReceivedInChannel(data: buffer.data! as NSData)
  }
    
  public func disconnect() {
    self.peerConnection?.close()
  }
}
