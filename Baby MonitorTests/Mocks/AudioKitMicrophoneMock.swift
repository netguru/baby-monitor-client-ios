//
//  AudioKitMicrophoneMock.swift
//  Baby MonitorTests
//

import Foundation
@testable import BabyMonitor

final class AudioKitMicrophoneMock: AudioKitMicrophoneProtocol {
    let record: MicrophoneRecordProtocol
    let capture: MicrophoneCaptureProtocol
    let tracker: MicrophoneFrequencyTracker
    
    init(record: MicrophoneRecordProtocol,
         capture: MicrophoneCaptureProtocol,
         tracker: MicrophoneFrequencyTracker) {
        self.record = record
        self.capture = capture
        self.tracker = tracker
    }
}
