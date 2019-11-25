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
import WebRTC

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
    private var mediaStreamInstance: MediaStream?
    private let mediaStreamPublisher = PublishSubject<MediaStream>()
    private let sdpAnswerPublisher = PublishSubject<SessionDescriptionProtocol>()
    private let iceCandidatePublisher = PublishSubject<IceCandidateProtocol>()

    private var peerConnection: PeerConnectionProtocol?
    private let peerConnectionFactory: PeerConnectionFactoryProtocol
    private let connectionDelegateProxy: RTCPeerConnectionDelegateProxy
    private let remoteDescriptionDelegateProxy: RTCSessionDescriptionDelegateProxy
    private let localDescriptionDelegateProxy: RTCSessionDescriptionDelegateProxy
    private let scheduler: AsyncScheduler

    private var streamMediaConstraints: RTCMediaConstraints {
        return RTCMediaConstraints(
            mandatoryConstraints: [:],
            optionalConstraints: [WebRtcConstraintKey.dtlsSrtpKeyAgreement: WebRtcConstraintValue.true]
        )
    }

    init(peerConnectionFactory: PeerConnectionFactoryProtocol, scheduler: AsyncScheduler = DispatchQueue.main) {
        self.peerConnectionFactory = peerConnectionFactory
        self.connectionDelegateProxy = RTCPeerConnectionDelegateProxy()
        self.remoteDescriptionDelegateProxy = RTCSessionDescriptionDelegateProxy()
        self.localDescriptionDelegateProxy = RTCSessionDescriptionDelegateProxy()
        self.scheduler = scheduler
        super.init()
        setup()
    }

    func setup() {
        connectionDelegateProxy.onGotIceCandidate = { [weak self] _, iceCandidate in
            guard let self = self else { return }
            self.iceCandidatePublisher.onNext(iceCandidate)
        }
    }

    func start() {
        guard !isStarted else { return }
        isStarted = true
        startMediaStream()
    }

    func stop() {
        peerConnection?.close()
        isStarted = false
    }
    private var videoCapturer: VideoCapturer?

    private func startMediaStream() {
        let (optionalCapturer, optionalStream) = peerConnectionFactory.createStream()
        guard let capturer = optionalCapturer, let stream = optionalStream else { return }
        videoCapturer = capturer
        mediaStreamInstance = stream
        mediaStreamPublisher.onNext(stream)
    }

    func pauseMediaStream() {
        videoCapturer?.stopCapture()
    }

    func resumeMediaStream() {
        startMediaStream()
    }

    func createAnswer(remoteSdp remoteSDP: SessionDescriptionProtocol) {
        guard isStarted else { return }
        peerConnection?.close()
        scheduler.scheduleAsync {
            self.peerConnection = self.peerConnectionFactory.peerConnection(with: self.connectionDelegateProxy)
            self.peerConnection?.setRemoteDescription(sdp: remoteSDP) { [weak self] error in
                guard error == nil, let stream = self?.mediaStreamInstance else { return }
                self?.handleDidSetRemoteDescription(stream: stream)
            }
        }
    }

    private func handleDidSetRemoteDescription(stream: MediaStream) {
        peerConnection?.add(stream: stream)
        peerConnection?.createAnswer(for: self.streamMediaConstraints) { [weak self] sdp, error in
            guard let self = self, let sdp = sdp else { return }
            self.peerConnection?.setLocalDescription(sdp: sdp) { _ in }
            self.sdpAnswerPublisher.onNext(sdp)
        }
    }
    
    func setICECandidates(iceCandidate: IceCandidateProtocol) {
        peerConnection?.add(iceCandidate: iceCandidate)
    }
    
}
