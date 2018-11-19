//
//  CryingRecordService.swift
//  Baby Monitor
//

import Foundation
import AudioKit
import RxSwift
import RxCocoa

protocol ErrorProducable {
    var errorObservable: Observable<Error> { get }
}

protocol AudioRecordServiceProtocol {
    var directoryDocumentsSavableObservable: Observable<DirectoryDocumentsSavable> { get }
    var isRecording: Bool { get }
    
    func stopRecording()
    func startRecording()
}

final class AudioRecordService: AudioRecordServiceProtocol, ErrorProducable {
    
    enum AudioError: Error {
        case initializationFailure
        case recordFailure
        case saveFailure
    }
    
    var isRecording = false
    lazy var errorObservable = errorSubject.asObservable()
    lazy var directoryDocumentsSavableObservable = directoryDocumentsSavableSubject.asObservable()
    
    private var recorder: RecorderProtocol?
    private let errorSubject = PublishSubject<Error>()
    private let directoryDocumentsSavableSubject = PublishSubject<DirectoryDocumentsSavable>()
    
    init(recorderFactory: () -> RecorderProtocol?) throws {
        recorder = recorderFactory()
        if recorder == nil {
            throw(AudioRecordService.AudioError.initializationFailure)
        }
    }
    
    func stopRecording() {
        guard isRecording else {
            return
        }
        recorder?.stop()
        isRecording = false
        guard let audioFile = recorder?.audioFile else {
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
            try recorder?.reset()
            try recorder?.record()
            isRecording = true
        } catch {
            errorSubject.onNext(AudioError.recordFailure)
        }        
    }
}

protocol RecorderProtocol: Any {
    var audioFile: AKAudioFile? { get }
    
    func stop()
    func record() throws
    func reset() throws
}

extension AKNodeRecorder: RecorderProtocol {}
