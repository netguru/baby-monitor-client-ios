//
//  NoiseDetectionService.swift
//  Baby Monitor

import RxSwift

protocol NoiseDetectionServiceProtocol {
    var loggingInfoPublisher: PublishSubject<String> { get }

    func handleLoudnessFactor(_ loudnessFactor: Double)
}

final class NoiseDetectionService: NoiseDetectionServiceProtocol {

    var loggingInfoPublisher = PublishSubject<String>()

    private let disposeBag = DisposeBag()

    func handleLoudnessFactor(_ loudnessFactor: Double) {
        guard loudnessFactor < Constants.loudnessFactorLimit else { return }
        loggingInfoPublisher.onNext("Loudness limit has been reached.")
        // TODO: send notification
    }
}
