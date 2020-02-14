//
//  MicrophoneTrackerMock.swift
//  Baby MonitorTests
//

import Foundation
@testable import BabyMonitor

final class MicrophoneTrackerMock: MicrophoneFrequencyTracker {

    var simulatedReturnedValues: [Double] = []
    var simulatedFrequencyLimit: Double = 2000
    var simulatedFrequencyStartValue: Double = 0

    var frequency: Double {
        return Double.random(in: simulatedFrequencyStartValue..<simulatedFrequencyLimit)
    }

}
