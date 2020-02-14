//
//  NoiseDetectionServiceMock.swift
//  Baby MonitorTests

import RxSwift
@testable import BabyMonitor

final class NoiseDetectionServiceMock: NoiseDetectionServiceProtocol {

    var loggingInfoPublisher = PublishSubject<String>()
    
    var receivedFrequencies: [Double] = []

    func handleFrequency(_ frequency: Double) {
        receivedFrequencies.append(frequency)
    }
}
