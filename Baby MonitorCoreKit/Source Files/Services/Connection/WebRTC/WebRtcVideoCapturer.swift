//
//  WebRtcVideoCapturer.swift
//  Baby Monitor
//

import WebRTC

protocol VideoCapturer {
    var isCapturing: Bool { get }
    func startCapturing()
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

    func startCapturing() {
        capturer.startCapture(with: device, format: format, fps: framesPerSecond) { [weak self] error in
            /// The error is error!, so it can be checked whether it actually is there or not. That's why, unfortunatelly, the true value will always be passed.
            self?.isCapturing = true
        }
    }

    func stopCapturing() {
        capturer.stopCapture { [weak self] in
            self?.isCapturing = false
        }
    }
}
