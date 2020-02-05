//
//  NoiseDetectionService.swift
//  Baby Monitor

import RxSwift

protocol NoiseDetectionServiceProtocol {
    func handleFrequency(_ frequency: Double)
}

final class NoiseDetectionService: NoiseDetectionServiceProtocol {

    private let disposeBag = DisposeBag()

    func handleFrequency(_ frequency: Double) {
        guard frequency < Constants.frequencyLimit else { return }
        // TODO: send notification
    }
}
