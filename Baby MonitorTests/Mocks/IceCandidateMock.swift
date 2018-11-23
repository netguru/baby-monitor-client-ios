//
//  IceCandidateMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

struct IceCandidateMock: IceCandidateProtocol, Equatable {
    let sdpMLineIndex: Int32
    let sdpMid: String?
    let sdp: String
}
