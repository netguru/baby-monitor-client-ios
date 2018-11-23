//
//  SessionDescriptionMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

struct SessionDescriptionMock: SessionDescriptionProtocol, Equatable {
    let sdp: String
    let stringType: String
}
