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

final class WebRtcServerManager: NSObject, PeerConnectionDelegate, SessionDescriptionDelegate, WebRtcServerManagerProtocol {

    var sdpAnswer: Observable<SessionDescriptionProtocol> {
        return sdpAnswerPublisher
    }
    var iceCandidate: Observable<IceCandidateProtocol> {
        return iceCandidatePublisher
    }
    var mediaStream: Observable<MediaStream> {
        return mediaStreamPublisher
    }
    
    private let mediaStreamPublisher = PublishSubject<MediaStream>()
    private let sdpAnswerPublisher = PublishSubject<SessionDescriptionProtocol>()
    private let iceCandidatePublisher = PublishSubject<IceCandidateProtocol>()

    private var capturer: VideoCapturer?
    private var peerConnection: PeerConnectionProtocol?
    private let peerConnectionFactory: PeerConnectionFactoryProtocol?
    private let connectionDelegateProxy: RTCPeerConnectionDelegate
    private let sessionDelegateProxy: RTCSessionDescriptionDelegate

    init(peerConnectionFactory: PeerConnectionFactoryProtocol, connectionDelegateProxy: RTCPeerConnectionDelegate, sessionDelegateProxy: RTCSessionDescriptionDelegate) {
        self.peerConnectionFactory = peerConnectionFactory
        self.connectionDelegateProxy = connectionDelegateProxy
        self.sessionDelegateProxy = sessionDelegateProxy
        peerConnection = peerConnectionFactory.peerConnection(with: connectionDelegateProxy)
        super.init()
    }
    
    func start() {
        addLocalMediaStream()
    }
    
    private func addLocalMediaStream() {
        peerConnectionFactory?.createStream { [weak self] stream, capturer in
            self?.capturer = capturer
            self?.mediaStreamPublisher.onNext(stream)
            self?.peerConnection?.add(stream: stream)
        }
    }
    
    func createConstraints() -> RTCMediaConstraints {
        let pairOfferToReceiveAudio = RTCPair(key: "OfferToReceiveAudio", value: "true")!
        let pairOfferToReceiveVideo = RTCPair(key: "OfferToReceiveVideo", value: "true")!
        let pairDtlsSrtpKeyAgreement = RTCPair(key: "DtlsSrtpKeyAgreement", value: "true")!
        let peerConnectionConstraints = RTCMediaConstraints(mandatoryConstraints: [pairOfferToReceiveVideo, pairOfferToReceiveAudio], optionalConstraints: [pairDtlsSrtpKeyAgreement])
        return peerConnectionConstraints!
    }
    
    func createAnswer(remoteSdp remoteSDP: SessionDescriptionProtocol) {
        DispatchQueue.main.async {
            self.peerConnection?.setRemoteDescription(sdp: remoteSDP, delegate: self.sessionDelegateProxy)
        }
    }
    
    func setICECandidates(iceCandidate: IceCandidateProtocol) {
        DispatchQueue.main.async {
            self.peerConnection?.add(iceCandidate: iceCandidate)
        }
    }

    func addedStream(_ stream: MediaStream) {}

    func gotIceCandidate(_ iceCandidate: IceCandidateProtocol) {
        iceCandidatePublisher.onNext(iceCandidate)
    }

    func didSetDescription() {
        let answerConstraints = self.createConstraints()
        self.peerConnection?.createAnswer(for: answerConstraints, delegate: sessionDelegateProxy)
    }

    func didCreateDescription(_ sdp: SessionDescriptionProtocol) {
        self.peerConnection?.setLocalDescription(sdp: sdp, delegate: sessionDelegateProxy)
        sdpAnswerPublisher.onNext(sdp)
    }

    func disconnect() {
        self.peerConnection?.close()
    }
}
