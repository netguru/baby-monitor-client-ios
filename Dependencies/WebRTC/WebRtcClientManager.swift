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
import RxCocoa
import WebRTC

final class WebRtcClientManager: NSObject, WebRtcClientManagerProtocol {

    var iceCandidate: Observable<IceCandidateProtocol> {
        return iceCandidatePublisher
    }
    var sdpOffer: Observable<SessionDescriptionProtocol> {
        return sdpOfferPublisher
    }
    var mediaStream: Observable<MediaStream?> {
        return mediaStreamPublisher
    }
    
    private var isStarted = false
    private(set) var connectionStatusObservable: Observable<WebSocketConnectionStatus>
    private let sdpOfferPublisher = PublishSubject<SessionDescriptionProtocol>()
    private let iceCandidatePublisher = PublishSubject<IceCandidateProtocol>()
    private let mediaStreamPublisher = BehaviorSubject<MediaStream?>(value: nil)
    private var connectionStatusPublisher = PublishSubject<WebSocketConnectionStatus>()
    private let disposeBag = DisposeBag()

    private var peerConnection: PeerConnectionProtocol?
    private let peerConnectionFactory: PeerConnectionFactoryProtocol
    private let appStateProvider: ApplicationStateProvider
    private let connectionDelegateProxy: RTCPeerConnectionDelegateProxy
    private let analytics: AnalyticsManager

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

    init(peerConnectionFactory: PeerConnectionFactoryProtocol,
         appStateProvider: ApplicationStateProvider,
         analytics: AnalyticsManager) {
        self.peerConnectionFactory = peerConnectionFactory
        self.appStateProvider = appStateProvider
        self.connectionDelegateProxy = RTCPeerConnectionDelegateProxy()
        self.analytics = analytics
        connectionStatusObservable = connectionStatusPublisher.asObservable()
        super.init()
        setup()
    }

    func setup() {

        connectionDelegateProxy.onAddedStream = { [weak self] _, stream in
            self?.mediaStreamPublisher.onNext(stream)
        }

        connectionDelegateProxy.onGotIceCandidate = { [weak self] _, iceCandidate in
            self?.iceCandidatePublisher.onNext(iceCandidate)
        }
        
        connectionDelegateProxy.onSignalingStateChanged = { [weak self] _, state in
            let newState = state.toSocketConnectionState()
            self?.connectionStatusPublisher.onNext(newState)
        }

        connectionDelegateProxy.onIceConnectionStateChanged = { [weak self] _, state in
            switch state {
            case .connected:
                self?.analytics.logEvent(.videoStreamConnected)
            case .failed:
                self?.analytics.logEvent(.videoStreamError)
            default: break
            }
        }

        appStateProvider.willEnterBackground
            .filter { [unowned self] in self.isStarted }
            .subscribe(onNext: { [unowned self] in self.pause() })
            .disposed(by: disposeBag)

        appStateProvider.willReenterForeground
            .filter { [unowned self] in self.isStarted }
            .subscribe(onNext: { [unowned self] in self.resume() })
            .disposed(by: disposeBag)

    }

    func startIfNeeded() {
        guard !isStarted else { return }
        isStarted = true
        createOffer()
    }

    func stop() {
        peerConnection?.close()
        isStarted = false
    }


    func setAnswerSDP(sdp: SessionDescriptionProtocol) {
        peerConnection?.setRemoteDescription(sdp: sdp) { _ in }
    }

    func setICECandidates(iceCandidate: IceCandidateProtocol) {
        peerConnection?.add(iceCandidate: iceCandidate)
    }

    private func pause() {
        peerConnection?.close()
    }

    private func resume() {
        createOffer()
    }

    private func createOffer() {
        peerConnection = peerConnectionFactory.peerConnection(with: connectionDelegateProxy)
        startAudioStream()
        peerConnection?.createOffer(for: streamMediaConstraints) { [weak self] sdp, error in
            guard let self = self, error == nil, let sdp = sdp else { return }
            self.peerConnection?.setLocalDescription(sdp: sdp) { _ in }
            self.sdpOfferPublisher.onNext(sdp)
        }
    }

    private func startAudioStream() {
        let stream = peerConnectionFactory.createAudioStream()
        peerConnection?.add(stream: stream)
    }
}
