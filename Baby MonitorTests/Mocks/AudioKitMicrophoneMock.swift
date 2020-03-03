//
//  AudioKitMicrophoneMock.swift
//  Baby MonitorTests
//

import Foundation
@testable import BabyMonitor

final class AudioKitMicrophoneMock: AudioKitMicrophoneProtocol {
    let capture: MicrophoneCaptureProtocol
    let tracker: MicrophoneAmplitudeTracker
    
    init(capture: MicrophoneCaptureProtocol,
         tracker: MicrophoneAmplitudeTracker) {
        self.capture = capture
        self.tracker = tracker
    }
}
