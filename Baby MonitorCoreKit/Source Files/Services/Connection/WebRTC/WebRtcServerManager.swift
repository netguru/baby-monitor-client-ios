//
//  WebrtcManager.swift
//  ConnectedColors
//
//  Created by Mahabali on 4/8/16.
//  Copyright © 2016 Ralf Ebert. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WebRtcServerManager: NSObject, WebRtcServerManagerProtocol {

    private let peerConnection: PeerConnectionProtocol
    private let streamFactory: StreamFactoryProtocol
    private var localSdp: SessionDescriptionProtocol?
    private var remoteSdp: SessionDescriptionProtocol?
    private var capturer: VideoCapturer?
    private var localStream: MediaStreamProtocol?

    var sdpAnswer: Observable<SessionDescriptionProtocol> {
        return sdpAnswerPublisher.asObservable()
    }
    private let sdpAnswerPublisher = PublishRelay<SessionDescriptionProtocol>()

    var iceCandidate: Observable<IceCandidateProtocol> {
        return iceCandidatePublisher.asObservable()
    }
    private let iceCandidatePublisher = PublishRelay<IceCandidateProtocol>()

    var mediaStream: Observable<MediaStreamProtocol> {
        return mediaStreamPublisher.asObservable()
    }
    private let mediaStreamPublisher = PublishRelay<MediaStreamProtocol>()

    init(peerConnection: PeerConnectionProtocol, streamFactory: StreamFactoryProtocol) {
        self.peerConnection = peerConnection
        self.streamFactory = streamFactory
    }
  
    private func addLocalMediaStream() {
        streamFactory.createStream { [weak self] stream, capturer in
            self?.capturer = capturer
            self?.localStream = stream
            self?.mediaStreamPublisher.accept(stream)
        }
    }
  
    private func createConstraints() -> RTCMediaConstraints {
        let peerConnectionConstraints = RTCMediaConstraints(mandatoryConstraints: [WebRtcConstraintKey.offerToReceiveAudio.rawValue: "true", WebRtcConstraintKey.offerToReceiveVideo.rawValue: "true"], optionalConstraints: [WebRtcConstraintKey.dtlsSrtpKeyAgreement.rawValue: "true"])
        return peerConnectionConstraints
    }

    func start() {
        addLocalMediaStream()
    }
  
    func createAnswer(remoteSdp: SessionDescriptionProtocol) {
        self.remoteSdp = remoteSdp
        peerConnection.setRemoteDescription(sdp: remoteSdp) { [weak self] _ in
            guard let answerConstraints = self?.createConstraints() else {
                return
            }
            self?.peerConnection.createAnswer(for: answerConstraints) { [weak self] sdp, _ in
                guard let sdp = sdp else {
                    return
                }
                self?.localSdp = sdp
                self?.peerConnection.setLocalDescription(sdp: sdp) { [weak self] _ in
                    guard let localStream = self?.localStream else { return }
                    self?.peerConnection.add(stream: localStream)
                }
                self?.sdpAnswerPublisher.accept(sdp)
            }
        }
    }
  
    func setICECandidates(iceCandidate: IceCandidateProtocol) {
        peerConnection.add(iceCandidate)
    }

    func disconnect() {
        peerConnection.close()
    }
}

extension WebRtcServerManager: RTCPeerConnectionDelegate {
    public func peerConnection(_ peerConnection: RTCPeerConnection, removedStreamam: RTCMediaStream) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        iceCandidatePublisher.accept(candidate)
    }

    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {}

    public func peerConnection(onRenegotiationNeeded peerConnection: RTCPeerConnection) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {}

    public func peerConnection(_ peerConnection: RTCPeerConnection, didSetSessionDescriptionWithError error: Error?) {
    }

    public func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {}
}
