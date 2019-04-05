//
//  AudioKitMicrophoneMock.swift
//  Baby MonitorTests
//

import Foundation
@testable import BabyMonitor

final class AudioKitMicrophoneMock: AudioKitMicrophoneProtocol {

    init(record: MicrophoneRecordProtocol, capture: MicrophoneCaptureProtocol) {
        self.record = record
        self.capture = capture
    }

    let record: MicrophoneRecordProtocol
    let capture: MicrophoneCaptureProtocol

}
