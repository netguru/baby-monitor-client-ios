//
//  SoundDetectionService.swift
//  Baby Monitor

import RxSwift

protocol SoundDetectionServiceProtocol {
    var mode: SoundDetectionMode { get }
    var cryingEventObservable: Observable<Void> { get }
    var loggingInfoPublisher: PublishSubject<String> { get }
    func startAnalysis() throws
    func stopAnalysis()
}

final class SoundDetectionService: SoundDetectionServiceProtocol {

    enum SoundDetectionServiceError: Error {
        case audioRecordServiceError
    }

    var mode: SoundDetectionMode {
        return .noiseDetection
//        return UserDefaults.soundDetectionMode
    }
    
    var cryingEventObservable: Observable<Void> {
        return cryingEventService.cryingEventObservable
    }

    var loggingInfoPublisher = PublishSubject<String>()

    private let microphoneService: AudioMicrophoneServiceProtocol?
    private let noiseDetectionService: NoiseDetectionServiceProtocol
    private let cryingEventService: CryingEventsServiceProtocol
    private let cryingDetectionService: CryingDetectionServiceProtocol
    private let disposeBag = DisposeBag()

    init(microphoneService: AudioMicrophoneServiceProtocol?,
         noiseDetectionService: NoiseDetectionServiceProtocol,
         cryingDetectionService: CryingDetectionServiceProtocol,
         cryingEventService: CryingEventsServiceProtocol) {
        self.microphoneService = microphoneService
        self.noiseDetectionService = noiseDetectionService
        self.cryingDetectionService = cryingDetectionService
        self.cryingEventService = cryingEventService
        rxSetup()
    }
    
    func startAnalysis() throws {
        microphoneService?.startCapturing()
        if microphoneService == nil {
            throw SoundDetectionServiceError.audioRecordServiceError
        }
    }

    func stopAnalysis() {
        microphoneService?.stopCapturing()
        guard self.microphoneService?.isRecording ?? false else {
            return
        }
        self.microphoneService?.stopRecording()
    }

    func rxSetup() {
        microphoneService?.microphoneAmplitudeObservable
            .subscribe(onNext: { [weak self] amplitudeInfo in
                guard self?.mode == .noiseDetection else { return }
                let roundedLoudnessFactor = String(format: "%.2f", amplitudeInfo.loudnessFactor)
                let roundedDecibels = String(format: "%.2f", amplitudeInfo.decibels)
                let infoText = "Current loundness factor: \(roundedLoudnessFactor) %" + "\n" +
                "\(roundedDecibels) db"
                self?.loggingInfoPublisher.onNext(infoText)
                self?.noiseDetectionService.handleLoudnessFactor(amplitudeInfo.loudnessFactor)
            }).disposed(by: disposeBag)

        microphoneService?.microphoneBufferReadableObservable
            .subscribe(onNext: { [weak self] bufferReadable in
                guard self?.mode == .machineLearningCryRecognition else { return }
                self?.cryingDetectionService.predict(on: bufferReadable)
            }).disposed(by: disposeBag)

        noiseDetectionService.loggingInfoPublisher.bind(to: loggingInfoPublisher).disposed(by: disposeBag)
        cryingEventService.loggingInfoPublisher.bind(to: loggingInfoPublisher).disposed(by: disposeBag)
    }

}
