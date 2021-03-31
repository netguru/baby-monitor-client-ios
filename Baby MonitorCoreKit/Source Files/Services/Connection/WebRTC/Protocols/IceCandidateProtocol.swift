//
//  IceCandidateProtocol.swift
//  Baby Monitor
//

import WebRTC

protocol IceCandidateProtocol {
    var sdpMLineIndex: Int32 { get }
    var sdpMid: String? { get }
    var sdp: String { get }
}

extension RTCIceCandidate: IceCandidateProtocol {}
