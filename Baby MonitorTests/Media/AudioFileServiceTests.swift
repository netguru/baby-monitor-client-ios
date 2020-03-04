//
//  AudioFileServiceTests.swift
//  Baby MonitorTests

import Foundation
import XCTest
import AVFoundation
import RxSwift
import RxTest
@testable import BabyMonitor

final class AudioFileServiceTests: XCTestCase {

    // swiftlint:disable implicitly_unwrapped_optional
    private var storageServiceMock: StorageServerServiceMock!
    private var audioFileStorageMock: AudioFileStorageMock!
    private var audioBufferConverterMock: AudioBufferConverterMock!

    private var initialCryingsAllowed: Bool!

    private var sut: AudioFileServiceProtocol!

    private var disposeBag: DisposeBag!
    // swiftlint:enable implicitly_unwrapped_optional

    override func setUp() {
        initialCryingsAllowed = UserDefaults.isSendingCryingsAllowed
        storageServiceMock = StorageServerServiceMock()
        audioFileStorageMock = AudioFileStorageMock()
        audioBufferConverterMock = AudioBufferConverterMock()
        sut = AudioFileService(storageService: storageServiceMock,
                               audioFileStorage: audioFileStorageMock,
                               audioBufferConverter: audioBufferConverterMock)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        UserDefaults.isSendingCryingsAllowed = initialCryingsAllowed
    }

    func testShouldNotProceeedIfRecordingsAreNotAllowed() {
        // Given
        UserDefaults.isSendingCryingsAllowed = false

        // When
        sut.uploadRecordingIfNeeded(from: AVAudioPCMBuffer(), audioRecordingURL: URL(string: "https://www.google.com/")!, filePrefixName: "")

        // Then
        XCTAssertFalse(audioBufferConverterMock.didTryToConvert)
        XCTAssertFalse(audioFileStorageMock.didWriteFile)
        XCTAssertFalse(storageServiceMock.wasUploadCalled)
    }

    func testShouldEmitErrorIfConvertionFailed() {
        // Given
        UserDefaults.isSendingCryingsAllowed = true
        audioBufferConverterMock.shouldConvert = false
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Error.self)
        sut.errorObservable.bind(to: observer).disposed(by: disposeBag)

        // When
        sut.uploadRecordingIfNeeded(from: AVAudioPCMBuffer(), audioRecordingURL: URL(string: "https://www.google.com/")!, filePrefixName: "")

        // Then
        XCTAssertTrue(observer.events.isNotEmpty)

        XCTAssertTrue(audioBufferConverterMock.didTryToConvert)
        XCTAssertFalse(audioFileStorageMock.didWriteFile)
        XCTAssertFalse(storageServiceMock.wasUploadCalled)
    }

    func testShouldProceedIfCryingsSendingAllowed() {
        // Given
        UserDefaults.isSendingCryingsAllowed = true
        audioBufferConverterMock.shouldConvert = true

        // When
        sut.uploadRecordingIfNeeded(from: AVAudioPCMBuffer(), audioRecordingURL: URL(string: "https://www.google.com/")!, filePrefixName: "")

        // Then
        XCTAssertTrue(audioBufferConverterMock.didTryToConvert)
        XCTAssertTrue(audioFileStorageMock.didWriteFile)
        XCTAssertTrue(storageServiceMock.wasUploadCalled)
    }

    func testAudioErrorsShouldBeConnected() {
        // Given
        UserDefaults.isSendingCryingsAllowed = true
        
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Error.self)
        sut.errorObservable.bind(to: observer).disposed(by: disposeBag)

        // When
        audioBufferConverterMock.errorPublisher.onNext(NSError())
        audioFileStorageMock.errorPublisher.onNext(NSError())
        sut.uploadRecordingIfNeeded(from: AVAudioPCMBuffer(), audioRecordingURL: URL(string: "https://www.google.com/")!, filePrefixName: "")

        // Then
        XCTAssertEqual(observer.events.count, 2)
    }
}
