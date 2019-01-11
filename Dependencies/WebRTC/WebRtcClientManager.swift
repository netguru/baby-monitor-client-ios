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
class WebRtcClientManager: NSObject, PeerConnectionDelegate, SessionDescriptionDelegate, WebRtcClientManagerProtocol {

    var iceCandidate: Observable<IceCandidateProtocol> {
        return iceCandidatePublisher
    }
    var sdpOffer: Observable<SessionDescriptionProtocol> {
        return sdpOfferPublisher
    }
    var mediaStream: Observable<MediaStream?> {
        return mediaStreamPublisher
    }
    
    private let sdpOfferPublisher = PublishSubject<SessionDescriptionProtocol>()
    private let iceCandidatePublisher = PublishSubject<IceCandidateProtocol>()
    private let mediaStreamPublisher = BehaviorSubject<MediaStream?>(value: nil)

    private let peerConnectionFactory: PeerConnectionFactoryProtocol?
    private var peerConnection: PeerConnectionProtocol?
    private let connectionDelegateProxy: RTCPeerConnectionDelegate
    private let sessionDelegateProxy: RTCSessionDescriptionDelegate

    init(peerConnectionFactory: PeerConnectionFactoryProtocol, connectionDelegateProxy: RTCPeerConnectionDelegate, sessionDelegateProxy: RTCSessionDescriptionDelegate) {
        self.peerConnectionFactory = peerConnectionFactory
        self.connectionDelegateProxy = connectionDelegateProxy
        self.sessionDelegateProxy = sessionDelegateProxy
        super.init()
    }
    
    func startWebRtcConnection() {
        peerConnection = peerConnectionFactory?.peerConnection(with: connectionDelegateProxy)
        createOffer()
    }
    
    private func createOffer() {
        let offerContratints = createConstraints()
        peerConnection?.createOffer(for: offerContratints, delegate: sessionDelegateProxy)
    }
    
    private func createConstraints() -> RTCMediaConstraints {
        let pairOfferToReceiveAudio = RTCPair(key: "OfferToReceiveAudio", value: "true")!
        let pairOfferToReceiveVideo = RTCPair(key: "OfferToReceiveVideo", value: "true")!
        let pairDtlsSrtpKeyAgreement = RTCPair(key: "DtlsSrtpKeyAgreement", value: "true")!
        let peerConnectionConstraints = RTCMediaConstraints(mandatoryConstraints: [pairOfferToReceiveVideo, pairOfferToReceiveAudio], optionalConstraints: [pairDtlsSrtpKeyAgreement])
        return peerConnectionConstraints!
    }
    
    func setAnswerSDP(sdp: SessionDescriptionProtocol) {
        DispatchQueue.main.async {
            self.peerConnection?.setRemoteDescription(sdp: sdp, delegate: self.sessionDelegateProxy)
        }
    }
    
    func setICECandidates(iceCandidate: IceCandidateProtocol) {
        DispatchQueue.main.async {
            self.peerConnection?.add(iceCandidate: iceCandidate)
        }
    }

    func addedStream(_ stream: MediaStream) {
        mediaStreamPublisher.onNext(stream)
    }

    func gotIceCandidate(_ iceCandidate: IceCandidateProtocol) {
        iceCandidatePublisher.onNext(iceCandidate)
    }

    func didSetDescription() {}

    func didCreateDescription(_ sdp: SessionDescriptionProtocol) {
        peerConnection?.setLocalDescription(sdp: sdp, delegate: sessionDelegateProxy)
        sdpOfferPublisher.onNext(sdp)
    }
    
    func disconnect() {
        peerConnection?.close()
    }
}
