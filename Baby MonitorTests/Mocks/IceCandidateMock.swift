//
//  IceCandidateMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

struct IceCandidateMock: IceCandidateProtocol, Equatable {
    var sdpMLineIndex: Int32
    var sdpMid: String?
    var sdp: String
}
