//
//  AudioBufferConverterTests.swift
//  Baby MonitorTests

import Foundation
import XCTest
import AVFoundation
import RxSwift
import RxTest
@testable import BabyMonitor

final class AudioBufferConverterTests: XCTestCase {

    // swiftlint:disable implicitly_unwrapped_optional

    private var sut: AudioBufferConvertable!

    private var disposeBag: DisposeBag!
    // swiftlint:enable implicitly_unwrapped_optional

    override func setUp() {
        sut = AudioBufferConverter()
        disposeBag = DisposeBag()
    }

    func testShouldEmitErrorAndReturnNilIfFailedToConvert() {
        // Given
        let buffer = AVAudioPCMBuffer()
        let url = URL(string: "https://google.com")!
        let prefix = "test"
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Error.self)
        sut.errorObservable.bind(to: observer).disposed(by: disposeBag)

        // When
        let file = sut.convertToFile(buffer: buffer, url: url, filePrefixName: prefix)

        // Then
        XCTAssertTrue(observer.events.isNotEmpty)
        XCTAssertTrue(file == nil)
    }
}
