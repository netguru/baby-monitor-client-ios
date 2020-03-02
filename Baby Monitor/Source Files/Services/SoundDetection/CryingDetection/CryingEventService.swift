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
    
    enum CryingEventServiceError: Error {
        case audioRecordServiceError
    }
    
    lazy var cryingEventObservable = cryingEventPublisher.asObservable()
    private(set) var loggingInfoPublisher = PublishSubject<String>()
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
    
    private func rxSetup() {
        cryingDetectionService.cryingDetectionObservable.subscribe(onNext: { [unowned self] cryingDetectionResult in
            let roundedProbability = String(format: "%.2f", cryingDetectionResult.probability)
            if cryingDetectionResult.isBabyCrying {
                self.loggingInfoPublisher.onNext("Crying detected. Probability: \(roundedProbability)")
                self.cryingEventPublisher.onNext(())

                self.convertToFile(buffer: cryingDetectionResult.buffer)
            } else {
//                self.storageService.uploadRecordingsToDatabaseIfAllowed()
                self.loggingInfoPublisher.onNext("Sound detected but no baby crying. Probability: \(roundedProbability)")
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

    private func convertToFile(buffer: AVAudioPCMBuffer) {
        let fileNameSuffix = DateFormatter.fullTimeFormatString(breakCharacter: "_")
        let outputFormatSettings = [
        AVLinearPCMBitDepthKey: 32,
        AVLinearPCMIsFloatKey: true,
        AVSampleRateKey: 44100,
        AVNumberOfChannelsKey: 1
        ] as [String: Any]
        self.nextFileName = "crying_".appending(fileNameSuffix).appending(".caf")
        var audioFile: AVAudioFile?
        createCryingRecordsFolderIfNeeded()
        do {
            audioFile = try AVAudioFile(forWriting: FileManager.cryingRecordsURL.appendingPathComponent(nextFileName), settings: outputFormatSettings, commonFormat: .pcmFormatFloat32, interleaved: false)
        } catch {
            Logger.error("Failed to create an audio file.", error: error)
        }

        do {
            try audioFile?.write(from: buffer)
        } catch {
            Logger.error("Failed to write an audio file.", error: error)
        }
        self.storageService.uploadRecordingsToDatabaseIfAllowed()
    }

    private func createCryingRecordsFolderIfNeeded() {
        let folderPath = FileManager.cryingRecordsURL
        if !FileManager.default.fileExists(atPath: folderPath.path) {
                try? FileManager.default.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true, attributes: nil)
        }
    }

}
