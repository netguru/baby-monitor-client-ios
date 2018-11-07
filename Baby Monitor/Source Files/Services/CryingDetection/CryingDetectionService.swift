//
//  CryingDetectionService.swift
//  Baby Monitor
//

import Foundation
import AudioKit
import RxSwift
import RxCocoa

protocol CryingDetectionServiceProtocol: Any {
    /// Observable that informs about detection of baby's cry
    var cryingDetectionObservable: Observable<Void> { get }
    
    /// Starts crying detection
    func startAnalysis()
    /// Stops crying detection
    func stopAnalysis()
}

final class CryingDetectionService {
    
    lazy var cryingDetectionObservable: Observable<Void> = {
        return Observable<Int>.timer(0, period: 0.5, scheduler: MainScheduler.asyncInstance)
            .map { _ in self.microphoneTracker.frequency }
            .filter { $0 > 1000 }
            .buffer(timeSpan: 10, count: 6, scheduler: MainScheduler.asyncInstance)
            .filter { $0.count > 5 }
            .map { _ in () }
    }()
    
    private let microphoneTracker: MicrophoneTrackerProtocol
    
    init(microphoneTracker: MicrophoneTrackerProtocol) {
        self.microphoneTracker = microphoneTracker
    }
    
    func startAnalysis() {
        microphoneTracker.start()
    }
    
    func stopAnalysis() {
        microphoneTracker.stop()
    }
}
