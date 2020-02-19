//
//  NoiseDetectionService.swift
//  Baby Monitor

import RxSwift

/// A service for detecting noise in the sound by custom limit set in the app.
protocol NoiseDetectionServiceProtocol {

    /// Notifying about a noise event.
    var noiseEventObservable: Observable<Void> { get }

    /// A debug info publisher.
    var loggingInfoPublisher: PublishSubject<String> { get }

    /// Handle a new amplitude counted from the sound.
    func handleAmplitude(_ amplitudeInfo: MicrophoneAmplitudeInfo)
}

final class NoiseDetectionService: NoiseDetectionServiceProtocol {

    lazy var noiseEventObservable: Observable<Void> = noiseEventPublisher.asObserver()

    var loggingInfoPublisher = PublishSubject<String>()
    
    private var noiseEventPublisher = PublishSubject<Void>()

    private let disposeBag = DisposeBag()

    func handleAmplitude(_ amplitudeInfo: MicrophoneAmplitudeInfo) {
        let roundedLoudnessFactor = String(format: "%.2f", amplitudeInfo.loudnessFactor)
        let roundedDecibels = String(format: "%.2f", amplitudeInfo.decibels)
        let infoText = "Current loundness factor: \(roundedLoudnessFactor) %" + "\n" +
               "\(roundedDecibels) db"
        loggingInfoPublisher.onNext(infoText)
        guard Int(amplitudeInfo.loudnessFactor) > UserDefaults.noiseLoudnessFactorLimit else { return }
        loggingInfoPublisher.onNext(infoText + "\n" + "Loudness limit has been reached.")
        noiseEventPublisher.onNext(())
    }
}
