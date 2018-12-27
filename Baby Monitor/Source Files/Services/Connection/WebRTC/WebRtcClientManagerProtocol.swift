//
//  WebRtcClientManagerProtocol.swift
//  Baby Monitor
//

import RxSwift

protocol WebRtcClientManagerProtocol {
    /// Starts WebRTC connection
    func startWebRtcConnection()

    /// Sets session description answer
    ///
    /// - Parameter sdp: session description protocol to add
    func setAnswerSDP(sdp: SessionDescriptionProtocol)

    /// Adds ice candidate
    ///
    /// - Parameter iceCandidate: ice candidate to add
    func setICECandidates(iceCandidate: IceCandidateProtocol)

    /// Closes connection
    func disconnect()

    /// Observable emitting session description offer
    var sdpOffer: Observable<SessionDescriptionProtocol> { get }

    /// Observable emitting ice candidates
    var iceCandidate: Observable<IceCandidateProtocol> { get }

    /// Observable emitting media stream
    var mediaStream: Observable<MediaStreamProtocol> { get }
}
