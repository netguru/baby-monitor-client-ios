//
//  VideoCapturerMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

struct VideoCapturerMock: VideoCapturer {
    func resumeCapturing() {}
    func stopCapturing() {}
}
