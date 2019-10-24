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
    var mediaStream: Observable<MediaStream> {
        return mediaStreamPublisher
    }

    private var isStarted = false
    private var mediaStreamInstance: MediaStream?
    private let mediaStreamPublisher = PublishSubject<MediaStream>()
    private let sdpAnswerPublisher = PublishSubject<SessionDescriptionProtocol>()

    private var peerConnection: PeerConnectionProtocol?
    private let peerConnectionFactory: PeerConnectionFactoryProtocol
    private let connectionDelegateProxy: RTCPeerConnectionDelegateProxy
    private let remoteDescriptionDelegateProxy: RTCSessionDescriptionDelegateProxy
    private let localDescriptionDelegateProxy: RTCSessionDescriptionDelegateProxy

    private var streamMediaConstraints: RTCMediaConstraints {
        return RTCMediaConstraints(
            mandatoryConstraints: [
                WebRtcConstraintKey.offerToReceiveVideo: WebRtcConstraintValue.true,
                WebRtcConstraintKey.offerToReceiveAudio: WebRtcConstraintValue.true
            ],
            optionalConstraints: [
                WebRtcConstraintKey.dtlsSrtpKeyAgreement: WebRtcConstraintValue.true
            ]
        )
    }

    init(peerConnectionFactory: PeerConnectionFactoryProtocol) {
        self.peerConnectionFactory = peerConnectionFactory
        self.connectionDelegateProxy = RTCPeerConnectionDelegateProxy()
        self.remoteDescriptionDelegateProxy = RTCSessionDescriptionDelegateProxy()
        self.localDescriptionDelegateProxy = RTCSessionDescriptionDelegateProxy()
        super.init()
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

    func createAnswer(remoteSdp remoteSDP: SessionDescriptionProtocol) {
        guard isStarted else { return }
        peerConnection?.close()
        peerConnection = peerConnectionFactory.peerConnection(with: connectionDelegateProxy)
        peerConnection?.setRemoteDescription(sdp: remoteSDP) { [weak self] error in
            guard error == nil, let stream = self?.mediaStreamInstance else { return }
            self?.handleDidSetRemoteDescription(stream: stream)
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
    
}
