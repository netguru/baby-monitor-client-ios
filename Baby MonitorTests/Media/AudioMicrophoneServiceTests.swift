//
//  AudioRecordServiceTests.swift
//  Baby MonitorTests
//

import XCTest
import AVFoundation
import RxSwift
import RxTest
@testable import BabyMonitor

final class AudioMicrophoneServiceTests: XCTestCase {

    // swiftlint:disable implicitly_unwrapped_optional
    private var capturerMock: MicrophoneCaptureMock!
    private var trackerMock: MicrophoneTrackerMock!
    private var microphoneMock: AudioKitMicrophoneMock!

    private var disposeBag: DisposeBag!

    private var sut: AudioMicrophoneService!
    // swiftlint:enable implicitly_unwrapped_optional

    override func setUp() {
        capturerMock = MicrophoneCaptureMock()
        trackerMock = MicrophoneTrackerMock()
        microphoneMock = AudioKitMicrophoneMock(capture: capturerMock, tracker: trackerMock)
        sut = try! AudioMicrophoneService(microphoneFactory: {
            return microphoneMock
        })

        disposeBag = DisposeBag()
    }

    func testShouldStartCapturing() {
        sut.startCapturing()

        XCTAssertTrue(capturerMock.isCapturing)
    }

    func testShouldStopCapturingIfStarted() {
        sut.startCapturing()
        sut.stopCapturing()

        XCTAssertFalse(capturerMock.isCapturing)
        XCTAssertTrue(capturerMock.didCallStopCapture)
    }

    func testShouldNotStopCapturingIfNotStarted() {
        sut.stopCapturing()

        XCTAssertFalse(capturerMock.didCallStopCapture)
    }

    func testShouldPassBufferWhenGotOne() {
        /// Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(AVAudioPCMBuffer.self)
        sut.microphoneBufferReadableObservable.bind(to: observer).disposed(by: disposeBag)

        // When
        sut.startCapturing()
        capturerMock.bufferPublisher.onNext(AVAudioPCMBuffer())

        // Then
        XCTAssertTrue(observer.events.isNotEmpty)
    }

    func testShouldPassAmplitudeInfoWhenGotBuffer() {
        /// Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(MicrophoneAmplitudeInfo.self)
        sut.microphoneAmplitudeObservable.bind(to: observer).disposed(by: disposeBag)

        // When
        sut.startCapturing()
        capturerMock.bufferPublisher.onNext(AVAudioPCMBuffer())

        // Then
        XCTAssertTrue(observer.events.isNotEmpty)
    }

    func testShouldEmmitErrorWhenGotItInBuffer() {
        /// Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Error.self)
        sut.errorObservable.bind(to: observer).disposed(by: disposeBag)

        // When
        sut.startCapturing()
        capturerMock.bufferPublisher.onError(NSError())

        // Then
        XCTAssertTrue(observer.events.isNotEmpty)
    }
}
