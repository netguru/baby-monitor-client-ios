//
//  MicrophoneTrackerMock.swift
//  Baby MonitorTests
//

import Foundation
@testable import BabyMonitor

final class MicrophoneTrackerMock: MicrophoneAmplitudeTracker {
    
    var amplitude: Double {
        return 0
    }

    var loudnessFactor: Double {
        return 20
    }

    var decibels: Double {
        return 60
    }

}
