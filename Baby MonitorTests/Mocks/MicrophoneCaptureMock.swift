//
//  MicrophoneCaptureMock.swift
//  Baby MonitorTests
//

import Foundation
import AudioKit
import RxSwift
@testable import BabyMonitor

final class MicrophoneCaptureMock: MicrophoneCaptureProtocol {

    let bufferPublisher = PublishSubject<AVAudioPCMBuffer>()
    lazy var bufferReadable = bufferPublisher.asObservable()
    var isCapturing = false
    var isCaptureReset = false
    var didCallStopCapture = false

    func stop() {
        isCapturing = false
        didCallStopCapture = true
    }

    func start() throws {
        isCapturing = true
    }

    func reset() throws {
        isCaptureReset = true
    }

}
