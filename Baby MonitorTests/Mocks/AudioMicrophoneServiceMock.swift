//
//  AudioMicrophoneServiceMock.swift
//  Baby MonitorTests
//

import AudioKit
import Foundation
import RxSwift
@testable import BabyMonitor

final class AudioMicrophoneServiceMock: AudioMicrophoneServiceProtocol {

    var isCapturing: Bool = false

    lazy var microphoneBufferReadableObservable: Observable<AVAudioPCMBuffer> = microphoneBufferReadablePublisher.asObservable()
    var microphoneBufferReadablePublisher = PublishSubject<AVAudioPCMBuffer>()

    lazy var microphoneAmplitudeObservable: Observable<MicrophoneAmplitudeInfo> = microphoneAmplitudePublisher.asObservable()
    let microphoneAmplitudePublisher = PublishSubject<MicrophoneAmplitudeInfo>()

    func stopCapturing() {
        isCapturing = false
        microphoneBufferReadablePublisher.onNext(AVAudioPCMBuffer())
    }

    func startCapturing() {
        isCapturing = true
    }

}
