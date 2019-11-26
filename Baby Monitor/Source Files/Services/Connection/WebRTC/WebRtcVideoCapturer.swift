//
//  WebRtcVideoCapturer.swift
//  Baby Monitor
//

import WebRTC

protocol VideoCapturer {
    var isCapturing: Bool { get }
    func resumeCapturing()
    func stopCapturing()
}

final class WebRTCVideoCapturer: VideoCapturer {

    private(set) var isCapturing = false
    private let device: AVCaptureDevice
    private let format: AVCaptureDevice.Format
    private let framesPerSecond: Int
    private let capturer: RTCCameraVideoCapturer

    init(device: AVCaptureDevice, format: AVCaptureDevice.Format, framesPerSecond: Int, capturer: RTCCameraVideoCapturer) {
        self.device = device
        self.format = format
        self.framesPerSecond = framesPerSecond
        self.capturer = capturer
    }

    func resumeCapturing() {
        capturer.startCapture(with: device, format: format, fps: framesPerSecond) { [weak self] _ in
            self?.isCapturing = true
        }
    }

    func stopCapturing() {
        capturer.stopCapture { [weak self] in
            self?.isCapturing = false
        }
    }
}
