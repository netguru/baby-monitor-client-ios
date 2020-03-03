//
//  SoundDetectionService.swift
//  Baby Monitor

import RxSwift

/// A service which handles a sound detection mode used in the app.
protocol SoundDetectionServiceProtocol {

    /// A current mode that is used.
    var mode: SoundDetectionMode { get }

    /// Notifying about a new noise event.
    var noiseEventObservable: Observable<Void> { get }

    /// Notifying about a new cry detection event.
    var cryDetectionEventObservable: Observable<Void> { get }

    /// A logging info used for debug purposes only.
    var loggingInfoPublisher: PublishSubject<String> { get }

    /// Start analysis of the sound by microphone.
    func startAnalysis() throws

    /// Stop analysis of the sound by microphone.
    func stopAnalysis()
}

final class SoundDetectionService: SoundDetectionServiceProtocol {

    enum SoundDetectionServiceError: Error {
        case audioRecordServiceError
    }

    var mode: SoundDetectionMode {
        return UserDefaults.soundDetectionMode
    }

    var noiseEventObservable: Observable<Void> {
        return noiseDetectionService.noiseEventObservable
    }
    
    var cryDetectionEventObservable: Observable<Void> {
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
    }

    private func rxSetup() {
        microphoneService?.microphoneAmplitudeObservable
            .subscribe(onNext: { [weak self] amplitudeInfo in
                guard let self = self,
                    self.mode == .noiseDetection else { return }
                self.noiseDetectionService.handleAmplitude(amplitudeInfo)
            }).disposed(by: disposeBag)

        microphoneService?.microphoneBufferReadableObservable
            .throttle(Constants.recognizingSoundTimeLimit, scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { [weak self] bufferReadable in
                guard self?.mode == .cryRecognition else { return }
                self?.cryingDetectionService.predict(on: bufferReadable)
            }).disposed(by: disposeBag)

        noiseDetectionService.loggingInfoPublisher.bind(to: loggingInfoPublisher).disposed(by: disposeBag)
        cryingEventService.loggingInfoPublisher.bind(to: loggingInfoPublisher).disposed(by: disposeBag)
    }
}
