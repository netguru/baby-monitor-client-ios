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
    var cryingDetectionObservable: Observable<Bool> { get }
    
    /// Starts crying detection
    func startAnalysis()
    /// Stops crying detection
    func stopAnalysis()
}

final class CryingDetectionService: CryingDetectionServiceProtocol {
    
    lazy var cryingDetectionObservable: Observable<Bool> = Observable<Int>.timer(0, period: 0.2, scheduler: MainScheduler.asyncInstance)
        .map { [unowned self] _ in self.microphoneTracker.frequency }
        .filter { $0 > 1000 }
        .buffer(timeSpan: 10, count: 10, scheduler: MainScheduler.asyncInstance)
        .map { $0.count > 9 }
        .distinctUntilChanged()
        .share()
    
    private var isCryingEventDetected = false
    private let microphoneTracker: MicrophoneTrackerProtocol
    private var bufferCount: Int {
        return isCryingEventDetected ? 1000 : 6
    }
    
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
