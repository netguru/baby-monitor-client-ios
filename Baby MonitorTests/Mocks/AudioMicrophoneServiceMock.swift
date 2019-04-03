//
//  AudioMicrophoneServiceMock.swift
//  Baby MonitorTests
//

import AudioKit
import Foundation
import RxSwift
@testable import BabyMonitor

final class AudioMicrophoneServiceMock: AudioMicrophoneServiceProtocol {

    lazy var directoryDocumentsSavableObservable: Observable<DirectoryDocumentsSavable> = directoryDocumentSavablePublihser.asObservable()
    var directoryDocumentSavablePublihser = PublishSubject<DirectoryDocumentsSavable>()
    var isRecording: Bool = false
    var isSaveActionSuccess = true

    func stopRecording() {
        isRecording = false
        directoryDocumentSavablePublihser.onNext(DocumentsSavableMock(isSaveSuccess: isSaveActionSuccess))
    }

    func startRecording() {
        isRecording = true
    }

    lazy var microphoneBufferReadableObservable: Observable<AVAudioPCMBuffer> = microphoneBufferReadablePublisher.asObservable()
    var microphoneBufferReadablePublisher = PublishSubject<AVAudioPCMBuffer>()
    var isCapturing: Bool = false

    func stopCapturing() {
        isCapturing = true
        microphoneBufferReadablePublisher.onNext(AVAudioPCMBuffer())
    }

    func startCapturing() {
        isCapturing = false
    }

}
