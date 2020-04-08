//
//  AudioBufferConverterMock.swift
//  Baby MonitorTests

import AVFoundation
import RxSwift
@testable import BabyMonitor

final class AudioBufferConverterMock: AudioBufferConvertable {

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
