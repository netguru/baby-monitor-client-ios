//
//  NoiseDetectionService.swift
//  Baby Monitor

import RxSwift

protocol NoiseDetectionServiceProtocol {
    var loggingInfoPublisher: PublishSubject<String> { get }

    func handleFrequency(_ frequency: Double)
}

final class NoiseDetectionService: NoiseDetectionServiceProtocol {

    var loggingInfoPublisher = PublishSubject<String>()

    private let disposeBag = DisposeBag()

    func handleFrequency(_ frequency: Double) {
        guard frequency < Constants.frequencyLimit else { return }
        loggingInfoPublisher.onNext("Frequency limit has been reached.")
        // TODO: send notification
    }
}
