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

    /// Sets session description answer
    ///
    /// - Parameter sdp: session description protocol to add
    func createAnswer(remoteSdp: SessionDescriptionProtocol)

    /// Observable emitting session description offer
    var sdpAnswer: Observable<SessionDescriptionProtocol> { get }

    /// Observable emitting media stream
    var mediaStream: Observable<MediaStream> { get }

}
