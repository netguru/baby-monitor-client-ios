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

    // swiftlint:disable implicitly_unwrapped_optional
    private var microphoneServiceMock: AudioMicrophoneServiceMock!
    private var noiseDetectionServiceMock: NoiseDetectionServiceMock!
    private var cryingDetectionServiceMock: CryingDetectionServiceMock!
    private var cryingEventsServiceMock: CryingEventsServiceMock!

    private var initialSoundDetectionMode: SoundDetectionMode!
    // swiftlint:enable implicitly_unwrapped_optional

    override func setUp() {
        microphoneServiceMock = AudioMicrophoneServiceMock()
        noiseDetectionServiceMock = NoiseDetectionServiceMock()
        cryingDetectionServiceMock = CryingDetectionServiceMock()
        cryingEventsServiceMock = CryingEventsServiceMock()
        initialSoundDetectionMode = UserDefaults.soundDetectionMode
    }

    override func tearDown() {
        UserDefaults.soundDetectionMode = initialSoundDetectionMode
    }

    func testShouldStartCapturing() {
        // Given
        let sut = makeSoundDetectionService()

        // When
        try! sut.startAnalysis()

        // Then
        XCTAssertTrue(microphoneServiceMock.isCapturing)
    }

    func testThrowWhenNoMicrophoneService() {
        // Given
        let sut = makeSoundDetectionService(withoutMicrophoneService: true)

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
        let sut = makeSoundDetectionService()

        // When
        try! sut.startAnalysis()
        sut.stopAnalysis()

        // Then
        XCTAssertFalse(microphoneServiceMock.isCapturing)
    }

    func testShouldHandleFrequencyWhenInMode() {
        // Given
        UserDefaults.soundDetectionMode = .noiseDetection
        let simulatedAmplitude = MicrophoneAmplitudeInfo(loudnessFactor: 0, decibels: 0)
        let sut = makeSoundDetectionService()

        // When
        try! sut.startAnalysis()
        microphoneServiceMock.microphoneAmplitudePublisher.onNext(simulatedAmplitude)

        // Then
        XCTAssertTrue(noiseDetectionServiceMock.receivedAmplitudes[0].loudnessFactor == simulatedAmplitude.loudnessFactor)
    }

    func testShouldNotHandleFrequencyWhenInMLMode() {
        // Given
        let simulatedAmplitude = MicrophoneAmplitudeInfo(loudnessFactor: 0, decibels: 0)
        UserDefaults.soundDetectionMode = .cryRecognition
        let sut = makeSoundDetectionService()

        // When
        try! sut.startAnalysis()
        microphoneServiceMock.microphoneAmplitudePublisher.onNext(simulatedAmplitude)

        // Then
        XCTAssertTrue(noiseDetectionServiceMock.receivedAmplitudes.isEmpty)
    }

    func testShouldPredictCryingWhenInMLMode() {
        // Given
        UserDefaults.soundDetectionMode = .cryRecognition
        let sut = makeSoundDetectionService()

        // When
        try! sut.startAnalysis()
        microphoneServiceMock.microphoneBufferReadablePublisher.onNext(AVAudioPCMBuffer())

        // Then
        XCTAssertTrue(cryingDetectionServiceMock.didPredict)
    }

}

private extension SoundDetectionServiceTests {

    func makeSoundDetectionService(withoutMicrophoneService: Bool = false) -> SoundDetectionService {
        return SoundDetectionService(microphoneService: withoutMicrophoneService ? nil : microphoneServiceMock,
                                     noiseDetectionService: noiseDetectionServiceMock,
                                     cryingDetectionService: cryingDetectionServiceMock,
                                     cryingEventService: cryingEventsServiceMock)
    }
}
