//
//  RecorderMock.swift
//  Baby MonitorTests
//

import Foundation
import AudioKit
@testable import BabyMonitor

final class RecorderMock: RecorderProtocol {
    
    var audioFile: AKAudioFile? {
        return shouldReturnNilForAudioFile ? nil : try! AKAudioFile()
    }
    
    var shouldReturnNilForAudioFile = false
    var isRecording = false
    var isRecordReset = false
    
    func stop() {
        isRecording = false
    }
    
    func record() throws {
        isRecording = true
    }
    
    func reset() throws {
        isRecordReset = true
    }
}
