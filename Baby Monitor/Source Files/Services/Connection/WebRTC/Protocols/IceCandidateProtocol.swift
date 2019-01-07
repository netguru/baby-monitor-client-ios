//
//  IceCandidateProtocol.swift
//  Baby Monitor
//

protocol IceCandidateProtocol {
    var sdpMLineIndex: Int32 { get }
    var sdpMid: String? { get }
    var sdp: String { get }
}

extension RTCICECandidate: IceCandidateProtocol {}
