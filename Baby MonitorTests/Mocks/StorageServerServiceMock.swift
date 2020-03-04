//
//  StorageServerServiceMock.swift
//  Baby MonitorTests
//

import Foundation
@testable import BabyMonitor

final class StorageServerServiceMock: StorageServerServiceProtocol {

    var wasUploadCalled = false

    func uploadRecordingsToDatabaseIfAllowed(for recordingsURL: URL) {
        wasUploadCalled = true
    }
}
