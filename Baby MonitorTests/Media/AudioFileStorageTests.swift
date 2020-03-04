//
//  AudioFileStorageTests.swift
//  Baby MonitorTests

import XCTest
import AVFoundation
import RxSwift
import RxTest
@testable import BabyMonitor

final class AudioFileStorageTests: XCTestCase {

    // swiftlint:disable implicitly_unwrapped_optional

    private var sut: AudioFileStorable!

    private var disposeBag: DisposeBag!
    // swiftlint:enable implicitly_unwrapped_optional

    override func setUp() {
        sut = AudioFileStorage()
        disposeBag = DisposeBag()
    }

    func testShouldEmitErrorAndReturnNilIfFailedToConvert() {
        // Given
        let file = AVAudioFile()
        let buffer = AVAudioPCMBuffer()
        let url = URL(string: "https://google.com")!
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Error.self)
        sut.errorObservable.bind(to: observer).disposed(by: disposeBag)

        // When
        sut.writeFile(file, from: buffer, at: url)

        // Then
        XCTAssertTrue(observer.events.isNotEmpty)
    }
}
