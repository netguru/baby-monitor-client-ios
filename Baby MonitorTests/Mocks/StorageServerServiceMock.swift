//
//  StorageServerServiceMock.swift
//  Baby MonitorTests
//

import Foundation
@testable import BabyMonitor

final class StorageServerServiceMock: StorageServerServiceProtocol {

    var wasUploadCalled = false

    func uploadRecordingsToDatabaseIfAllowed() {
        wasUploadCalled = true
    }
}
