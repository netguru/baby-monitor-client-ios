//
//  NetServiceServerMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

final class NetServiceServerMock: NetServiceServerProtocol {

    private(set) var isStarted = false

    func publish() {
        isStarted = true
    }

    func stop() {
        isStarted = false
    }
}
