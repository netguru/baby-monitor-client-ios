//
//  AudioRecordServiceMock.swift
//  Baby MonitorTests
//

import Foundation
import RxSwift
@testable import BabyMonitor

final class AudioRecordServiceMock: AudioRecordServiceProtocol {

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
}
