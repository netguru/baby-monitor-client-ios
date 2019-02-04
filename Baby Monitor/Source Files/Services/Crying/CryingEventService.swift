//
//  CryingEventService.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import RxCocoa

protocol CryingEventsServiceProtocol: Any {
    var cryingEventObservable: Observable<EventMessage> { get }
    
    /// Starts work of crying events service
    func start() throws
    /// Stops work of crying events service
    func stop()
}

final class CryingEventService: CryingEventsServiceProtocol, ErrorProducable {
    
    enum CryingEventServiceError: Error {
        case audioRecordServiceError
    }
    
    lazy var cryingEventObservable: Observable<EventMessage> = cryingEventPublisher.asObservable()
    lazy var errorObservable = errorPublisher.asObservable()
    private var nextFileName: String = ""
    
    private let cryingEventPublisher = PublishSubject<EventMessage>()
    private let errorPublisher = PublishSubject<Error>()
    private let cryingDetectionService: CryingDetectionServiceProtocol
    private let audioRecordService: AudioRecordServiceProtocol?
    private let activityLogEventsRepository: ActivityLogEventsRepositoryProtocol
    private let storageService: StorageServerServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(cryingDetectionService: CryingDetectionServiceProtocol, audioRecordService: AudioRecordServiceProtocol?, activityLogEventsRepository: ActivityLogEventsRepositoryProtocol, storageService: StorageServerServiceProtocol) {
        self.cryingDetectionService = cryingDetectionService
        self.audioRecordService = audioRecordService
        self.activityLogEventsRepository = activityLogEventsRepository
        self.storageService = storageService
        rxSetup()
    }
    
    func start() throws {
        cryingDetectionService.startAnalysis()
        if audioRecordService == nil {
            throw CryingEventServiceError.audioRecordServiceError
        }
    }
    
    func stop() {
        cryingDetectionService.stopAnalysis()
        audioRecordService?.stopRecording()
    }
    
    private func rxSetup() {
        cryingDetectionService.cryingDetectionObservable.subscribe(onNext: { [unowned self] isBabyCrying in
            if isBabyCrying {
                let fileNameSuffix = DateFormatter.fullTimeFormatString(breakCharacter: "_")
                self.nextFileName = "crying_".appending(fileNameSuffix).appending(".caf")
                self.audioRecordService?.startRecording()
                let cryingEventMessage = EventMessage.initWithCryingEvent(value: self.nextFileName)
                self.cryingEventPublisher.onNext(cryingEventMessage)
            } else {
                guard self.audioRecordService?.isRecording ?? false else {
                    return
                }
                self.audioRecordService?.stopRecording()
            }
        }).disposed(by: disposeBag)
        
        audioRecordService?.directoryDocumentsSavableObservable.subscribe(onNext: { [unowned self] savableFile in
            savableFile.save(withName: self.nextFileName, completion: { [unowned self] result in
                switch result {
                case .success:
                    self.storageService.uploadRecordingsToDatabaseIfAllowed()
                case .failure(let error):
                    self.errorPublisher.onNext(error ?? AudioRecordService.AudioError.saveFailure)
                }
            })
        }).disposed(by: disposeBag)
    }
}
