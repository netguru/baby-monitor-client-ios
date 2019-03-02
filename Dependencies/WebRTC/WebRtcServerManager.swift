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

final class WebRtcServerManager: NSObject, WebRtcServerManagerProtocol {

    var sdpAnswer: Observable<SessionDescriptionProtocol> {
        return sdpAnswerPublisher
    }
    var iceCandidate: Observable<IceCandidateProtocol> {
        return iceCandidatePublisher
    }
    var mediaStream: Observable<MediaStream> {
        return mediaStreamPublisher
    }

    private var isStarted = false
    private let mediaStreamPublisher = PublishSubject<MediaStream>()
    private let sdpAnswerPublisher = PublishSubject<SessionDescriptionProtocol>()
    private let iceCandidatePublisher = PublishSubject<IceCandidateProtocol>()

    private var peerConnection: PeerConnectionProtocol?
    private let peerConnectionFactory: PeerConnectionFactoryProtocol
    private let connectionDelegateProxy: RTCPeerConnectionDelegateProxy
    private let remoteDescriptionDelegateProxy: RTCSessionDescriptionDelegateProxy
    private let localDescriptionDelegateProxy: RTCSessionDescriptionDelegateProxy

    private var streamMediaConstraints: RTCMediaConstraints {
        return RTCMediaConstraints(
            mandatoryConstraints: [
                RTCPair(key: WebRtcConstraintKey.offerToReceiveVideo, value: WebRtcConstraintValue.true)!,
                RTCPair(key: WebRtcConstraintKey.offerToReceiveAudio, value: WebRtcConstraintValue.true)!
            ],
            optionalConstraints: [
                RTCPair(key: WebRtcConstraintKey.dtlsSrtpKeyAgreement, value: WebRtcConstraintValue.true)!
            ]
        )
    }

    init(peerConnectionFactory: PeerConnectionFactoryProtocol) {
        self.peerConnectionFactory = peerConnectionFactory
        self.connectionDelegateProxy = RTCPeerConnectionDelegateProxy()
        self.remoteDescriptionDelegateProxy = RTCSessionDescriptionDelegateProxy()
        self.localDescriptionDelegateProxy = RTCSessionDescriptionDelegateProxy()
        super.init()
        setup()
    }

    func setup() {

        connectionDelegateProxy.onGotIceCandidate = { [weak self] _, iceCandidate in
            guard let `self` = self else { return }
            self.iceCandidatePublisher.onNext(iceCandidate)
        }

        remoteDescriptionDelegateProxy.onDidSetSessionDescription = { [weak self] connection in
            guard let `self` = self else { return }
            self.peerConnectionFactory.createStream { stream in
                connection.add(stream: stream)
                // 💩 It looks like escaping the stream from this closure to be
                // used in ServerViewController's view as a live preview causes
                // problems when closing and reopening the peer connection when
                // a new offer is received. Another method of live preview needs
                // to be used, e.g. straight from AVFoundation.
                //
                // self.mediaStreamPublisher.onNext(stream)
            }
            connection.createAnswer(for: self.streamMediaConstraints, delegate: self.localDescriptionDelegateProxy)
        }

        localDescriptionDelegateProxy.onDidCreateSessionDescription = { [weak self] connection, sdp in
            guard let `self` = self else { return }
            connection.setLocalDescription(sdp: sdp, delegate: self.localDescriptionDelegateProxy)
            self.sdpAnswerPublisher.onNext(sdp)
        }

    }

    func start() {
        guard !isStarted else { return }
        isStarted = true
    }

    func stop() {
        peerConnection?.close()
        isStarted = false
    }

    func createAnswer(remoteSdp remoteSDP: SessionDescriptionProtocol) {
        if isStarted {
            peerConnection?.close()
            peerConnection = peerConnectionFactory.peerConnection(with: connectionDelegateProxy)
            peerConnection?.setRemoteDescription(sdp: remoteSDP, delegate: remoteDescriptionDelegateProxy)
        }
    }
    
    func setICECandidates(iceCandidate: IceCandidateProtocol) {
        peerConnection?.add(iceCandidate: iceCandidate)
    }
    
}
