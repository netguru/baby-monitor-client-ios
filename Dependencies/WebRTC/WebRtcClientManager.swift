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

    lazy var state: Observable<WebRtcClientManagerState> = {
        Observable.combineLatest(connectionChecker.connectionStatus, connectionDelegateProxy.signalingState)
            .map { connStatus, peerState -> WebRtcClientManagerState? in
                switch (connStatus, peerState) {
                case (.disconnected, _), (_, .closed): return .disconnected
                case (.connected, .haveLocalOffer): return .connecting
                case (.connected, .stable): return .connected
                default: return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }()
    
    private var isStarted = false
    private let sdpOfferPublisher = PublishSubject<SessionDescriptionProtocol>()
    private let iceCandidatePublisher = PublishSubject<IceCandidateProtocol>()
    private let mediaStreamPublisher = BehaviorSubject<MediaStream?>(value: nil)
    private let disposeBag = DisposeBag()

    private var peerConnection: PeerConnectionProtocol?
    private let peerConnectionFactory: PeerConnectionFactoryProtocol
    private let connectionChecker: ConnectionChecker
    private let appStateProvider: ApplicationStateProvider
    private let connectionDelegateProxy: RTCPeerConnectionDelegateProxy

    private var streamMediaConstraints: RTCMediaConstraints {
        return RTCMediaConstraints(
            mandatoryConstraints: [
                WebRtcConstraintKey.offerToReceiveVideo: WebRtcConstraintValue.true,
                WebRtcConstraintKey.offerToReceiveAudio: WebRtcConstraintValue.true
            ],
            optionalConstraints: [
                WebRtcConstraintKey.dtlsSrtpKeyAgreement: WebRtcConstraintValue.true,
                WebRtcConstraintKey.iceRestart: WebRtcConstraintValue.true
            ]
        )
    }

    init(peerConnectionFactory: PeerConnectionFactoryProtocol, connectionChecker: ConnectionChecker, appStateProvider: ApplicationStateProvider) {
        self.peerConnectionFactory = peerConnectionFactory
        self.connectionChecker = connectionChecker
        self.appStateProvider = appStateProvider
        self.connectionDelegateProxy = RTCPeerConnectionDelegateProxy()
        super.init()
        setup()
    }

    func setup() {

        connectionDelegateProxy.onAddedStream = { [weak self] _, stream in
            guard let self = self else { return }
            self.mediaStreamPublisher.onNext(stream)
        }

        connectionDelegateProxy.onGotIceCandidate = { [weak self] _, iceCandidate in
            guard let self = self else { return }
            self.iceCandidatePublisher.onNext(iceCandidate)
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

    private func pause() {
        peerConnection?.close()
    }

    private func resume() {
        createOffer()
    }

    private func createOffer() {
        peerConnection = peerConnectionFactory.peerConnection(with: connectionDelegateProxy)
        peerConnection?.createOffer(for: streamMediaConstraints) { [weak self] sdp, error in
            guard let self = self, error == nil, let sdp = sdp else { return }
            self.peerConnection?.setLocalDescription(sdp: sdp) { _ in }
            self.sdpOfferPublisher.onNext(sdp)
        }
    }

    func setAnswerSDP(sdp: SessionDescriptionProtocol) {
        peerConnection?.setRemoteDescription(sdp: sdp) { _ in }
    }
    
    func setICECandidates(iceCandidate: IceCandidateProtocol) {
        peerConnection?.add(iceCandidate: iceCandidate)
    }
}
