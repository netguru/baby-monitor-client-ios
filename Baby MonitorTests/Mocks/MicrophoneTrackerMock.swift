//
//  MicrophoneTrackerMock.swift
//  Baby MonitorTests
//

import Foundation
@testable import BabyMonitor

final class MicrophoneTrackerMock: MicrophoneTrackerProtocol {

    var simulatedReturnedValues: [Double] = []
    var simulatedFrequencyLimit: Double = 2000
    var simulatedFrequencyStartValue: Double = 0

    var frequency: Double {
        guard isTrackingRunning else {
            return 0
        }
        if !simulatedReturnedValues.isEmpty {
            return simulatedReturnedValues.remove(at: 0)
        }
        return Double.random(in: simulatedFrequencyStartValue..<simulatedFrequencyLimit)
    }

    private var isTrackingRunning = true

    func start() {
        isTrackingRunning = true
    }

    func stop() {
        isTrackingRunning = false
    }
}
