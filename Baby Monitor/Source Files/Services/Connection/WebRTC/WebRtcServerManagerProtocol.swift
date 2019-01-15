//
//  WebRtcServerManagerProtocol.swift
//  Baby Monitor
//

import RxSwift

protocol WebRtcServerManagerProtocol {
    /// Sets session description answer
    ///
    /// - Parameter sdp: session description protocol to add
    func createAnswer(remoteSdp: SessionDescriptionProtocol)

    /// Adds ice candidate
    ///
    /// - Parameter iceCandidate: ice candidate to add
    func setICECandidates(iceCandidate: IceCandidateProtocol)

    /// Closes connection
    func disconnect()

    /// Observable emitting session description offer
    var sdpAnswer: Observable<SessionDescriptionProtocol> { get }

    /// Observable emitting ice candidates
    var iceCandidate: Observable<IceCandidateProtocol> { get }

    /// Observable emitting media stream
    var mediaStream: Observable<MediaStream> { get }

    func start()
}
