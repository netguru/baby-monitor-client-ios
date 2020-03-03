//
//  AudioRecordServiceTests.swift
//  Baby MonitorTests
//

import XCTest
import RxSwift
@testable import BabyMonitor

class AudioMicrophoneServiceTests: XCTestCase {
    
    //Given
    lazy var capturerMock = MicrophoneCaptureMock()
    lazy var trackerMock = MicrophoneTrackerMock()
    lazy var microphoneMock = AudioKitMicrophoneMock(capture: capturerMock, tracker: trackerMock)

    lazy var sut = try! AudioMicrophoneService(microphoneFactory: {
        return microphoneMock
    })
    
    override func setUp() {
        sut = try! AudioMicrophoneService(microphoneFactory: {
            return microphoneMock
        })
    }
}
