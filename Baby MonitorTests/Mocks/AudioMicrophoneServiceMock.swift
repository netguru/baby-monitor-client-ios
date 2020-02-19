//
//  AudioMicrophoneServiceMock.swift
//  Baby MonitorTests
//

import AudioKit
import Foundation
import RxSwift
@testable import BabyMonitor

final class AudioMicrophoneServiceMock: AudioMicrophoneServiceProtocol {

    var isRecording: Bool = false
    var isSaveActionSuccess = true
    var isCapturing: Bool = false
    
    lazy var directoryDocumentsSavableObservable: Observable<DirectoryDocumentsSavable> = directoryDocumentSavablePublihser.asObservable()
    var directoryDocumentSavablePublihser = PublishSubject<DirectoryDocumentsSavable>()

    lazy var microphoneBufferReadableObservable: Observable<AVAudioPCMBuffer> = microphoneBufferReadablePublisher.asObservable()
    var microphoneBufferReadablePublisher = PublishSubject<AVAudioPCMBuffer>()

    lazy var microphoneAmplitudeObservable: Observable<MicrophoneAmplitudeInfo> = microphoneAmplitudePublisher.asObservable()
    let microphoneAmplitudePublisher = PublishSubject<MicrophoneAmplitudeInfo>()

    func stopRecording() {
        isRecording = false
        directoryDocumentSavablePublihser.onNext(DocumentsSavableMock(isSaveSuccess: isSaveActionSuccess))
    }

    func startRecording() {
        isRecording = true
    }

    func stopCapturing() {
        isCapturing = false
        microphoneBufferReadablePublisher.onNext(AVAudioPCMBuffer())
    }

    func startCapturing() {
        isCapturing = true
    }

}
