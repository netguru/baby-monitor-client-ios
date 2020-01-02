//
//  WebRtcClientManagerProtocol.swift
//  Baby Monitor
//

import RxSwift

protocol WebRtcClientManagerProtocol: WebSocketConnectionStatusProvider {

    /// Starts WebRTC connection if not started yet
    func startIfNeeded()

    /// Closes connection
    func stop()

    /// Sets session description answer
    ///
    /// - Parameter sdp: session description protocol to add
    func setAnswerSDP(sdp: SessionDescriptionProtocol)

    /// Adds ice candidate
    ///
    /// - Parameter iceCandidate: ice candidate to add
    func setICECandidates(iceCandidate: IceCandidateProtocol)

    /// Observable emitting session description offer
    var sdpOffer: Observable<SessionDescriptionProtocol> { get }

    /// Observable emitting ice candidates
    var iceCandidate: Observable<IceCandidateProtocol> { get }

    /// Observable emitting media stream
    var mediaStream: Observable<MediaStream?> { get }

}
