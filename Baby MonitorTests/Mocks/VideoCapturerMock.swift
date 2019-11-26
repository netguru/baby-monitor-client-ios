//
//  VideoCapturerMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

final class VideoCapturerMock: VideoCapturer {

    private(set) var isCapturing = false

    func resumeCapturing() {
        isCapturing = true
    }

    func stopCapturing() {
        isCapturing = false
    }
}
