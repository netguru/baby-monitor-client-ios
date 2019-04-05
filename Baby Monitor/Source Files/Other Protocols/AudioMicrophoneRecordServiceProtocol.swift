//
//  AudioMicrophoneRecordServiceProtocol.swift
//  Baby Monitor
//

import RxSwift

protocol AudioMicrophoneRecordServiceProtocol {
    var directoryDocumentsSavableObservable: Observable<DirectoryDocumentsSavable> { get }
    var isRecording: Bool { get }
    
    func stopRecording()
    func startRecording()
}
