//
//  CryingDetectionServiceMock.swift
//  Baby MonitorTests
//

import Foundation
import RxSwift
import AVFoundation
@testable import BabyMonitor

final class CryingDetectionServiceMock: CryingDetectionServiceProtocol {
    
    lazy var cryingDetectionObservable: Observable<CryingDetectionResult> = cryingDetectionPublisher.asObservable()
    var cryingDetectionPublisher = PublishSubject<CryingDetectionResult>()
    var analysisStarted = false
    var didPredict = false
    
    func startAnalysis() {
        analysisStarted = true
    }
    
    func stopAnalysis() {
        analysisStarted = false
    }
    
    func notifyAboutCryingDetection(isBabyCrying isCrying: Bool) {
        cryingDetectionPublisher.onNext(CryingDetectionResult(isBabyCrying: isCrying, probability: 1))
    }

    func predict(on bufferReadable: AVAudioPCMBuffer) {
        didPredict = true
    }

}
