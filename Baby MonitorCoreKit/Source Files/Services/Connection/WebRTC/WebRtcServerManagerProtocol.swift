//
//  WebRtcServerManagerProtocol.swift
//  Baby Monitor
//

import RxSwift

protocol WebRtcServerManagerProtocol {

    /// Opens connection for offers.
    func start()

    /// Closes connection
    func stop()

    /// Pauses video streaming.
    func pauseMediaStream()

    /// Resumes video streaming.
    func resumeMediaStream()

    /// Sets session description answer
    ///
    /// - Parameters:
    ///     - sdp: session description protocol to add.
    ///     - completion: a completion called when the creating answer was finished.
    func createAnswer(remoteSdp: SessionDescriptionProtocol, completion: @escaping (_ isSuccessful: Bool) -> Void)

    /// Adds ice candidate
    ///
    /// - Parameter iceCandidate: ice candidate to add
    func setICECandidates(iceCandidate: IceCandidateProtocol)

    /// Observable emitting session description offer
    var sdpAnswer: Observable<SessionDescriptionProtocol> { get }

    /// Observable emitting ice candidates
    var iceCandidate: Observable<IceCandidateProtocol> { get }

    /// Observable emitting media stream
    var mediaStream: Observable<WebRTCMediaStream> { get }

}
