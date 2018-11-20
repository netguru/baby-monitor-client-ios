//
//  WebRtcClientManagerProtocol.swift
//  Baby Monitor
//

import WebRTC
import RxSwift

protocol WebRtcClientManagerProtocol {
    func startWebRtcConnection()
    func setAnswerSDP(sdp: SessionDescriptionProtocol)
    func setICECandidates(iceCandidate: IceCandidateProtocol)
    func disconnect()

    var sdpOffer: Observable<SessionDescriptionProtocol> { get }
    var iceCandidate: Observable<IceCandidateProtocol> { get }
    var mediaStream: Observable<RTCMediaStream> { get }
}
