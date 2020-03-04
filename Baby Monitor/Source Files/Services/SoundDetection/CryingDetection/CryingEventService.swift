//
//  CryingEventService.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import RxCocoa
import AVFoundation

protocol CryingEventsServiceProtocol: Any {
    var cryingEventObservable: Observable<Void> { get }

    var loggingInfoPublisher: PublishSubject<String> { get }
}

final class CryingEventService: CryingEventsServiceProtocol, ErrorProducable {

    lazy var cryingEventObservable = cryingEventPublisher.asObservable()
    private(set) var loggingInfoPublisher = PublishSubject<String>()
    var errorObservable: Observable<Error> {
        return audioFileService.errorObservable
    }
    private let cryingEventPublisher = PublishSubject<Void>()
    private let cryingDetectionService: CryingDetectionServiceProtocol
    private let audioFileService: AudioFileServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(cryingDetectionService: CryingDetectionServiceProtocol,
         audioFileService: AudioFileServiceProtocol) {
        self.cryingDetectionService = cryingDetectionService
        self.audioFileService = audioFileService
        rxSetup()
    }
    
    private func rxSetup() {
        cryingDetectionService.cryingDetectionObservable.subscribe(onNext: { [unowned self] cryingDetectionResult in
            let roundedProbability = String(format: "%.2f", cryingDetectionResult.probability)
            if cryingDetectionResult.isBabyCrying {
                self.loggingInfoPublisher.onNext("Crying detected. Probability: \(roundedProbability)")
                self.cryingEventPublisher.onNext(())
                self.audioFileService.uploadRecordingIfNeeded(from: cryingDetectionResult.buffer, audioRecordingURL: FileManager.cryingRecordsURL, filePrefixName: "crying_")
            } else {
                self.loggingInfoPublisher.onNext("Sound detected but no baby crying. Probability: \(roundedProbability)")
            }
        }).disposed(by: disposeBag)
    }
}
