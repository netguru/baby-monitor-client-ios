//
//  NoiseDetectionServiceMock.swift
//  Baby MonitorTests

import RxSwift
@testable import BabyMonitor

final class NoiseDetectionServiceMock: NoiseDetectionServiceProtocol {
    lazy var noiseEventObservable: Observable<Void> = noiseEventPublisher.asObservable()

    private var noiseEventPublisher = PublishSubject<Void>()

    var loggingInfoPublisher = PublishSubject<String>()

    var receivedAmplitudes: [MicrophoneAmplitudeInfo] = []

    func handleAmplitude(_ amplitudeInfo: MicrophoneAmplitudeInfo) {
        receivedAmplitudes.append(amplitudeInfo)
    }
}
