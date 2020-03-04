//
//  AudioFileServiceMock.swift
//  Baby MonitorTests

import Foundation
import AVFoundation
import RxSwift
@testable import BabyMonitor

final class AudioFileServiceMock: AudioFileServiceProtocol {

    lazy var errorObservable = errorPublisher.asObservable()

    let errorPublisher = PublishSubject<Error>()

    var didUploadRecording = false

    func uploadRecordingIfNeeded(from buffer: AVAudioPCMBuffer, audioRecordingURL: URL, filePrefixName: String) {
        didUploadRecording = true
    }
}
