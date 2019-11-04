//
//  ServerErrorLoggerMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

final class ServerErrorLoggerMock: ServerErrorLogger {
    
    func log(error: Error) {}

    func log(error: Error, additionalInfo: [String: Any]) {}
}
