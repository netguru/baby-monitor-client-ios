//
//  VoiceDetectionService.swift
//  Baby Monitor

import RxSwift

protocol VoiceDetectionServiceProtocol {
    var mode: VoiceDetectionMode { get }
    var cryingEventObservable: Observable<Void> { get }
    var loggingInfoPublisher: PublishSubject<String> { get }
    func startAnalysis() throws
    func stopAnalysis()
}

final class VoiceDetectionService: VoiceDetectionServiceProtocol {

    enum VoiceDetectionServiceError: Error {
        case audioRecordServiceError
    }

    var mode: VoiceDetectionMode {
        return UserDefaults.voiceDetectionMode
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
            throw VoiceDetectionServiceError.audioRecordServiceError
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
        microphoneService?.microphoneFrequencyObservable
            .subscribe(onNext: { [weak self] frequency in
                guard self?.mode == .noiseDetection else { return }
                let roundedFrequency = String(format: "%.2f", frequency)
                self?.loggingInfoPublisher.onNext("Current frequency: \(roundedFrequency) Hz")
                self?.noiseDetectionService.handleFrequency(frequency)
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
