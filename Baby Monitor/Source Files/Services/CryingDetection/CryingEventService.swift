//
//  CryingEventService.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import RxCocoa

protocol CryingEventsServiceProtocol: Any {
    var cryingEventObservable: Observable<Void> { get }
    
    /// Starts work of crying events service
    func start() throws
    /// Stops work of crying events service
    func stop()
}

final class CryingEventService: CryingEventsServiceProtocol, ErrorProducable {
    
    enum CryingEventServiceError: Error {
        case audioRecordServiceError
    }
    
    lazy var cryingEventObservable = cryingEventPublisher.asObservable()
    lazy var errorObservable = errorPublisher.asObservable()
    private var nextFileName: String = ""
    
    private let cryingEventPublisher = PublishSubject<Void>()
    private let errorPublisher = PublishSubject<Error>()
    private let cryingDetectionService: CryingDetectionServiceProtocol
    private let microphoneRecordService: AudioMicrophoneRecordServiceProtocol?
    private let activityLogEventsRepository: ActivityLogEventsRepositoryProtocol
    private let storageService: StorageServerServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(cryingDetectionService: CryingDetectionServiceProtocol, microphoneRecordService: AudioMicrophoneRecordServiceProtocol?, activityLogEventsRepository: ActivityLogEventsRepositoryProtocol, storageService: StorageServerServiceProtocol) {
        self.cryingDetectionService = cryingDetectionService
        self.microphoneRecordService = microphoneRecordService
        self.activityLogEventsRepository = activityLogEventsRepository
        self.storageService = storageService
        rxSetup()
    }
    
    func start() throws {
        cryingDetectionService.startAnalysis()
        if microphoneRecordService == nil {
            throw CryingEventServiceError.audioRecordServiceError
        }
    }
    
    func stop() {
        cryingDetectionService.stopAnalysis()
        guard self.microphoneRecordService?.isRecording ?? false else {
            return
        }
        self.microphoneRecordService?.stopRecording()
    }
    
    private func rxSetup() {
        cryingDetectionService.cryingDetectionObservable.subscribe(onNext: { [unowned self] isBabyCrying in
            if isBabyCrying {
                let fileNameSuffix = DateFormatter.fullTimeFormatString(breakCharacter: "_")
                self.nextFileName = "crying_".appending(fileNameSuffix).appending(".caf")
                self.microphoneRecordService?.startRecording()
                self.cryingEventPublisher.onNext(())
            } else {
                guard self.microphoneRecordService?.isRecording ?? false else {
                    return
                }
                self.microphoneRecordService?.stopRecording()
            }
        }).disposed(by: disposeBag)
        
        microphoneRecordService?.directoryDocumentsSavableObservable.subscribe(onNext: { [unowned self] savableFile in
            savableFile.save(withName: self.nextFileName, completion: { [unowned self] result in
                switch result {
                case .success:
                    self.storageService.uploadRecordingsToDatabaseIfAllowed()
                case .failure(let error):
                    self.errorPublisher.onNext(error ?? AudioMicrophoneService.AudioError.saveFailure)
                }
            })
        }).disposed(by: disposeBag)
    }
}
