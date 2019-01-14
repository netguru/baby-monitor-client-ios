//
//  IceCandidateMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

struct IceCandidateMock: IceCandidateProtocol, Equatable {
    var sdpMLineIndex: Int
    var sdpMid: String!
    var sdp: String!
}
