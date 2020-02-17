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
        let simulatedAmplitude = MicrophoneAmplitudeInfo(loudnessFactor: 0, decibels: 0)
        let sut = SoundDetectionService(microphoneService: microphoneServiceMock,
                                        noiseDetectionService: noiseDetectionServiceMock,
                                        cryingDetectionService: cryingDetectionServiceMock,
                                        cryingEventService: cryingEventsServiceMock)

        // When
        try! sut.startAnalysis()
        microphoneServiceMock.microphoneAmplitudePublisher.onNext(simulatedAmplitude)

        // Then
        XCTAssertTrue(noiseDetectionServiceMock.receivedAmplitudes[0].loudnessFactor == simulatedAmplitude.loudnessFactor)
    }

    func testShouldNotHandleFrequencyWhenInMLMode() {
        // Given
        let microphoneServiceMock = AudioMicrophoneServiceMock()
        let noiseDetectionServiceMock = NoiseDetectionServiceMock()
        let cryingDetectionServiceMock = CryingDetectionServiceMock()
        let cryingEventsServiceMock = CryingEventsServiceMock()
        let simulatedAmplitude = MicrophoneAmplitudeInfo(loudnessFactor: 0, decibels: 0)
        UserDefaults.soundDetectionMode = .cryRecognition
        let sut = SoundDetectionService(microphoneService: microphoneServiceMock,
                                        noiseDetectionService: noiseDetectionServiceMock,
                                        cryingDetectionService: cryingDetectionServiceMock,
                                        cryingEventService: cryingEventsServiceMock)

        // When
        try! sut.startAnalysis()
        microphoneServiceMock.microphoneAmplitudePublisher.onNext(simulatedAmplitude)

        // Then
        XCTAssertTrue(noiseDetectionServiceMock.receivedAmplitudes.isEmpty)
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
