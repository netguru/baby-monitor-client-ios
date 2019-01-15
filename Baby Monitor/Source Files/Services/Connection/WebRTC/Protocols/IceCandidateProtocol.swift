//
//  IceCandidateProtocol.swift
//  Baby Monitor
//

protocol IceCandidateProtocol {
    var sdpMLineIndex: Int { get }
    var sdpMid: String! { get }
    var sdp: String! { get }
}

extension RTCICECandidate: IceCandidateProtocol {}
