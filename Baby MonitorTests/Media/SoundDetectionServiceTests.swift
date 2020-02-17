//
//  SoundDetectionService.swift
//  Baby MonitorTests

import Foundation
import XCTest
import RxSwift
import RxTest
import AVFoundation
@testable import BabyMonitor

class SoundDetectionServiceTests: XCTestCase {

    func testShouldStartCapturing() {
        // Given
        let microphoneServiceMock = AudioMicrophoneServiceMock()
        let noiseDetectionServiceMock = NoiseDetectionServiceMock()
        let cryingDetectionServiceMock = CryingDetectionServiceMock()
        let cryingEventsServiceMock = CryingEventsServiceMock()
        let sut = SoundDetectionService(microphoneService: microphoneServiceMock,
                                        noiseDetectionService: noiseDetectionServiceMock,
                                        cryingDetectionService: cryingDetectionServiceMock,
                                        cryingEventService: cryingEventsServiceMock)

        // When
        try! sut.startAnalysis()

        // Then
        XCTAssertTrue(microphoneServiceMock.isCapturing)
    }

    func testShouldNotStartRecordingAudio() {
        // Given
        let microphoneServiceMock = AudioMicrophoneServiceMock()
        let noiseDetectionServiceMock = NoiseDetectionServiceMock()
        let cryingDetectionServiceMock = CryingDetectionServiceMock()
        let cryingEventsServiceMock = CryingEventsServiceMock()
        let sut = SoundDetectionService(microphoneService: microphoneServiceMock,
                                        noiseDetectionService: noiseDetectionServiceMock,
                                        cryingDetectionService: cryingDetectionServiceMock,
                                        cryingEventService: cryingEventsServiceMock)

        // When
        try! sut.startAnalysis()

        // Then
        XCTAssertFalse(microphoneServiceMock.isRecording)
    }

    func testThrowWhenNoMicrophoneService() {
        // Given
        let noiseDetectionServiceMock = NoiseDetectionServiceMock()
        let cryingDetectionServiceMock = CryingDetectionServiceMock()
        let cryingEventsServiceMock = CryingEventsServiceMock()
        let sut = SoundDetectionService(microphoneService: nil,
                                        noiseDetectionService: noiseDetectionServiceMock,
                                        cryingDetectionService: cryingDetectionServiceMock,
                                        cryingEventService: cryingEventsServiceMock)

        // When
        do {
            try sut.startAnalysis()
            XCTFail("Should throw when no microphone.")
        } catch {
            // Then
            XCTAssert(true)
        }
    }

    func testShouldStopCapturing() {
        // Given
        let microphoneServiceMock = AudioMicrophoneServiceMock()
        let noiseDetectionServiceMock = NoiseDetectionServiceMock()
        let cryingDetectionServiceMock = CryingDetectionServiceMock()
        let cryingEventsServiceMock = CryingEventsServiceMock()
        let sut = SoundDetectionService(microphoneService: microphoneServiceMock,
                                        noiseDetectionService: noiseDetectionServiceMock,
                                        cryingDetectionService: cryingDetectionServiceMock,
                                        cryingEventService: cryingEventsServiceMock)

        // When
        try! sut.startAnalysis()
        sut.stopAnalysis()

        // Then
        XCTAssertFalse(microphoneServiceMock.isCapturing)
    }

    func testShouldStopRecording() {
        // Given
        let microphoneServiceMock = AudioMicrophoneServiceMock()
        let noiseDetectionServiceMock = NoiseDetectionServiceMock()
        let cryingDetectionServiceMock = CryingDetectionServiceMock()
        let cryingEventsServiceMock = CryingEventsServiceMock()
        let sut = SoundDetectionService(microphoneService: microphoneServiceMock,
                                        noiseDetectionService: noiseDetectionServiceMock,
                                        cryingDetectionService: cryingDetectionServiceMock,
                                        cryingEventService: cryingEventsServiceMock)

        // When
        try! sut.startAnalysis()
        microphoneServiceMock.startRecording()
        sut.stopAnalysis()

        // Then
        XCTAssertFalse(microphoneServiceMock.isRecording)
    }

    func testShouldHandleFrequencyWhenInMode() {
        // Given
        let microphoneServiceMock = AudioMicrophoneServiceMock()
        let noiseDetectionServiceMock = NoiseDetectionServiceMock()
        let cryingDetectionServiceMock = CryingDetectionServiceMock()
        let cryingEventsServiceMock = CryingEventsServiceMock()
        UserDefaults.soundDetectionMode = .noiseDetection
        let simulatedFrequency: Double = 120
        let sut = SoundDetectionService(microphoneService: microphoneServiceMock,
                                        noiseDetectionService: noiseDetectionServiceMock,
                                        cryingDetectionService: cryingDetectionServiceMock,
                                        cryingEventService: cryingEventsServiceMock)

        // When
        try! sut.startAnalysis()
        microphoneServiceMock.microphoneFrequencyPublisher.onNext(simulatedFrequency)

        // Then
        XCTAssertTrue(noiseDetectionServiceMock.receivedFrequencies.first == simulatedFrequency)
    }

    func testShouldNotHandleFrequencyWhenInMLMode() {
        // Given
        let microphoneServiceMock = AudioMicrophoneServiceMock()
        let noiseDetectionServiceMock = NoiseDetectionServiceMock()
        let cryingDetectionServiceMock = CryingDetectionServiceMock()
        let cryingEventsServiceMock = CryingEventsServiceMock()
        let simulatedFrequency: Double = 120
        UserDefaults.soundDetectionMode = .cryRecognition
        let sut = SoundDetectionService(microphoneService: microphoneServiceMock,
                                        noiseDetectionService: noiseDetectionServiceMock,
                                        cryingDetectionService: cryingDetectionServiceMock,
                                        cryingEventService: cryingEventsServiceMock)

        // When
        try! sut.startAnalysis()
        microphoneServiceMock.microphoneFrequencyPublisher.onNext(simulatedFrequency)

        // Then
        XCTAssertTrue(noiseDetectionServiceMock.receivedFrequencies.isEmpty)
    }

    func testShouldPredictCryingWhenInMLMode() {
        // Given
        let microphoneServiceMock = AudioMicrophoneServiceMock()
        let noiseDetectionServiceMock = NoiseDetectionServiceMock()
        let cryingDetectionServiceMock = CryingDetectionServiceMock()
        let cryingEventsServiceMock = CryingEventsServiceMock()
        UserDefaults.soundDetectionMode = .cryRecognition
        let sut = SoundDetectionService(microphoneService: microphoneServiceMock,
                                        noiseDetectionService: noiseDetectionServiceMock,
                                        cryingDetectionService: cryingDetectionServiceMock,
                                        cryingEventService: cryingEventsServiceMock)

        // When
        try! sut.startAnalysis()
        microphoneServiceMock.microphoneBufferReadablePublisher.onNext(AVAudioPCMBuffer())

        // Then
        XCTAssertTrue(cryingDetectionServiceMock.didPredict)
    }

}
