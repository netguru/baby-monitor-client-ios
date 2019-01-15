//
//  StorageServerServiceMock.swift
//  Baby MonitorTests
//

import Foundation
@testable import BabyMonitor

final class StorageServerServiceMock: StorageServerServiceProtocol {
    func uploadRecordingsToDatabase() { }
    func uploadRecordingsToDatabaseIfNeeded() { }
}
