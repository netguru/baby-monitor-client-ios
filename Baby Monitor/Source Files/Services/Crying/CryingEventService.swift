//
//  CryingEventService.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import RxCocoa

protocol CryingEventsServiceProtocol: Any {
    var cryingEventObservable: Observable<Bool> { get }
    
    /// Starts work of crying events service
    func start()
    /// Stops work of crying events service
    func stop()
}

final class CryingEventService: CryingEventsServiceProtocol, ErrorProducable {
    
    lazy var cryingEventObservable: Observable<Bool> = cryingEventPublisher.asObservable()
    lazy var errorObservable = errorPublisher.asObservable()
    
    private let cryingEventPublisher = PublishSubject<Bool>()
    private let errorPublisher = PublishSubject<Error>()
    private let cryingDetectionService: CryingDetectionServiceProtocol
    private let audioRecordService: AudioRecordServiceProtocol?
    private let babiesRepository: CryingEventsRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    init(cryingDetectionService: CryingDetectionServiceProtocol, audioRecordService: AudioRecordServiceProtocol?, babiesRepository: CryingEventsRepositoryProtocol) {
        self.cryingDetectionService = cryingDetectionService
        self.audioRecordService = audioRecordService
        self.babiesRepository = babiesRepository
        
        rxSetup()
    }
    
    func start() {
        cryingDetectionService.startAnalysis()
    }
    
    func stop() {
        cryingDetectionService.stopAnalysis()
        audioRecordService?.stopRecording()
    }
    
    private func rxSetup() {
        cryingDetectionService.cryingDetectionObservable.subscribe(onNext: { [unowned self] isBabyCrying in
            if isBabyCrying {
                self.audioRecordService?.startRecording()
                self.cryingEventPublisher.onNext(true)
            } else {
                guard self.audioRecordService?.isRecording ?? false else {
                    return
                }
                self.audioRecordService?.stopRecording()
                self.cryingEventPublisher.onNext(false)
            }
        }).disposed(by: disposeBag)
        
        audioRecordService?.directoryDocumentsSavableObservable.subscribe(onNext: { savableFile in
            let fileName = UUID().uuidString
            savableFile.save(withName: fileName, completion: { [unowned self] result in
                switch result {
                case .success:
                    let cryingEvent = CryingEvent(fileName: fileName)
                    self.babiesRepository.save(cryingEvent: cryingEvent)
                case .failure(let error):
                    self.errorPublisher.onNext(error ?? AudioRecordService.AudioError.saveFailure)
                }
            })
        }).disposed(by: disposeBag)
    }
}
