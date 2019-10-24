//
//  WebRtcClientManagerProtocol.swift
//  Baby Monitor
//

import RxSwift

/// Describes different states that the WebRTC client can be in.
enum WebRtcClientManagerState {

    /// The client is disconnected and waiting for a server to show up.
    case disconnected

    /// The client found a server and is now connecting to it.
    case connecting

    /// The client has a stable connection to a server.
    case connected

}

protocol WebRtcClientManagerProtocol {

    /// Starts WebRTC connection if not started yet
    func startIfNeeded()

    /// Closes connection
    func stop()

    /// Sets session description answer
    ///
    /// - Parameter sdp: session description protocol to add
    func setAnswerSDP(sdp: SessionDescriptionProtocol)

    /// Observable emitting session description offer
    var sdpOffer: Observable<SessionDescriptionProtocol> { get }

    /// Observable emitting media stream
    var mediaStream: Observable<MediaStream?> { get }

    /// Obervable emitting client state.
    var state: Observable<WebRtcClientManagerState> { get }
    
}
