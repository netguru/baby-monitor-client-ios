//
//  AudioBufferConverterMock.swift
//  Baby MonitorTests

import AVFoundation
import RxSwift
import AVFoundation
@testable import BabyMonitor

final class AudioBufferConverterMock: AudioBufferConvertertable {

    lazy var errorObservable = errorPublisher.asObservable()

    var shouldConvert = true
    var didTryToConvert = false

    let errorPublisher = PublishSubject<Error>()

    func convertToFile(buffer: AVAudioPCMBuffer, url: URL, filePrefixName: String) -> AVAudioFile? {
        didTryToConvert = true
        if shouldConvert {
            return AVAudioFile()
        } else {
            return nil
        }
    }
}
