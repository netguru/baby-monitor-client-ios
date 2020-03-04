//
//  AudioFileStorageMock.swift
//  Baby MonitorTests

import AVFoundation
import RxSwift
@testable import BabyMonitor

final class AudioFileStorageMock: AudioFileStorable {

    lazy var errorObservable = errorPublisher.asObservable()

    var didWriteFile = false

    let errorPublisher = PublishSubject<Error>()

    func writeFile(_ audioFile: AVAudioFile, from buffer: AVAudioPCMBuffer, at url: URL) {
        didWriteFile = true
    }
}
