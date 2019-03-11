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

protocol AudioMicrophoneRecordServiceProtocol {
    var directoryDocumentsSavableObservable: Observable<DirectoryDocumentsSavable> { get }
    var isRecording: Bool { get }
    
    func stopRecording()
    func startRecording()
}

protocol AudioMicrophoneCaptureServiceProtocol {
    var microphoneBufferReadableObservable: Observable<AVAudioPCMBuffer> { get }
    var isCapturing: Bool { get }
    
    func stopCapturing()
    func startCapturing()
}

protocol AudioMicrophoneServiceProtocol: AudioMicrophoneRecordServiceProtocol, AudioMicrophoneCaptureServiceProtocol {}

final class AudioMicrophoneService: AudioMicrophoneServiceProtocol, ErrorProducable {
   
    enum AudioError: Error {
        case initializationFailure
        case captureFailure
        case recordFailure
        case saveFailure
    }
    
    lazy var errorObservable = errorSubject.asObservable()
    lazy var microphoneBufferReadableObservable = microphoneBufferReadableSubject.asObservable()
    lazy var directoryDocumentsSavableObservable = directoryDocumentsSavableSubject.asObservable()
    
    private(set) var isCapturing = false
    private(set) var isRecording = false
    
    private var capture: MicrophoneCaptureProtocol
    private var record: MicrophoneRecordProtocol
    
    private let errorSubject = PublishSubject<Error>()
    private let microphoneBufferReadableSubject = PublishSubject<AVAudioPCMBuffer>()
    private let directoryDocumentsSavableSubject = PublishSubject<DirectoryDocumentsSavable>()
    
    private let disposeBag = DisposeBag()

    init(microphoneFactory: () throws -> AudioKitMicrophoneProtocol?) throws {
        guard let audioKitMicrophone = try microphoneFactory() else {
            throw(AudioMicrophoneService.AudioError.initializationFailure)
        }
        capture = audioKitMicrophone.capture
        record = audioKitMicrophone.record
        rxSetup()
    }
    
    func stopCapturing() {
        guard isCapturing else {
            return
        }
        capture.stop()
        isCapturing = false
    }
    
    func startCapturing() {
        guard !isCapturing else {
            return
        }
        do {
            try capture.start()
        } catch {
            return
        }
        isCapturing = true
    }
    
    func stopRecording() {
        guard isRecording else {
            return
        }
        record.stop()
        isRecording = false
        guard let audioFile = record.audioFile else {
            errorSubject.onNext(AudioError.recordFailure)
            return
        }
        directoryDocumentsSavableSubject.onNext(audioFile)
    }
    
    func startRecording() {
        guard !isRecording else {
            return
        }
        do {
            try record.reset()
            try record.record()
            isRecording = true
        } catch {
            errorSubject.onNext(AudioError.recordFailure)
        }
    }

    private func rxSetup() {
        capture.bufferReadable.subscribe(onNext: { [unowned self] bufferReadable in
            self.microphoneBufferReadableSubject.onNext(bufferReadable)
        }).disposed(by: disposeBag)
    }

}
