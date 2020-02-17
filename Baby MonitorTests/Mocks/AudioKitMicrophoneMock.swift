//
//  AudioKitMicrophoneMock.swift
//  Baby MonitorTests
//

import Foundation
@testable import BabyMonitor

final class AudioKitMicrophoneMock: AudioKitMicrophoneProtocol {
    let record: MicrophoneRecordProtocol
    let capture: MicrophoneCaptureProtocol
    let tracker: MicrophoneAmplitudeTracker
    
    init(record: MicrophoneRecordProtocol,
         capture: MicrophoneCaptureProtocol,
         tracker: MicrophoneAmplitudeTracker) {
        self.record = record
        self.capture = capture
        self.tracker = tracker
    }
}
