//
//  VideoCapturerMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

final class VideoCapturerMock: VideoCapturer {

    private(set) var isCapturing = false

    func startCapturing() {
        isCapturing = true
    }

    func stopCapturing() {
        isCapturing = false
    }
}
