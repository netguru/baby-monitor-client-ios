//
//  AudioMicrophoneService.swift
//  Baby Monitor
//

import Foundation
import AudioKit
import RxSwift
import RxCocoa

protocol ErrorProducable {
    var errorObservable: Observable<Error> { get }
}

protocol AudioMicrophoneServiceProtocol: AudioMicrophoneCaptureServiceProtocol {}

final class AudioMicrophoneService: AudioMicrophoneServiceProtocol, ErrorProducable {
   
    enum AudioError: Error {
        case initializationFailure
        case captureFailure
    }
    
    lazy var errorObservable = errorSubject.asObservable()
    lazy var microphoneBufferReadableObservable = microphoneBufferReadableSubject.asObservable()
    lazy var microphoneAmplitudeObservable = microphoneAmplitudeSubject.asObservable()
    
    private(set) var isCapturing = false
    
    private var microphoneCapturer: MicrophoneCaptureProtocol
    private var microphoneTracker: MicrophoneAmplitudeTracker

    private let errorSubject = PublishSubject<Error>()
    private let microphoneBufferReadableSubject = PublishSubject<AVAudioPCMBuffer>()
    private let microphoneAmplitudeSubject = PublishSubject<MicrophoneAmplitudeInfo>()
    
    private let disposeBag = DisposeBag()

    init(microphoneFactory: () throws -> AudioKitMicrophoneProtocol?) throws {
        guard let audioKitMicrophone = try microphoneFactory() else {
            throw(AudioMicrophoneService.AudioError.initializationFailure)
        }
        microphoneCapturer = audioKitMicrophone.capture
        microphoneTracker = audioKitMicrophone.tracker
        rxSetup()
    }

    func startCapturing() {
        guard !isCapturing else {
            return
        }
        do {
            try microphoneCapturer.start()
        } catch {
            Logger.error("Microphone coudn't start capturing", error: error)
            return
        }
        isCapturing = true
    }

    func stopCapturing() {
        guard isCapturing else {
            return
        }
        microphoneCapturer.stop()
        isCapturing = false
    }

    private func rxSetup() {
        microphoneCapturer.bufferReadable
            .subscribe(onNext: { [weak self] bufferReadable in
                guard let self = self else { return }
                let amplitudeInfo = MicrophoneAmplitudeInfo(loudnessFactor: self.microphoneTracker.loudnessFactor, decibels: self.microphoneTracker.decibels)
                self.microphoneAmplitudeSubject.onNext(amplitudeInfo)
                self.microphoneBufferReadableSubject.onNext(bufferReadable)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.errorSubject.onNext(error)
            }).disposed(by: disposeBag)
    }

}
