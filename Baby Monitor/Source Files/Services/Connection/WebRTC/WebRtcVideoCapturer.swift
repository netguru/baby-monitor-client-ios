//
//  WebRtcVideoCapturer.swift
//  Baby Monitor
//

import WebRTC

protocol VideoCapturer {
    func resumeCapturing()
    func stopCapturing()
}

struct WebRTCVideoCapturer: VideoCapturer {

    private let device: AVCaptureDevice
    private let format: AVCaptureDevice.Format
    private let fps: Int
    private let capturer: RTCCameraVideoCapturer

    func resumeCapturing() {
        capturer.startCapture(with: device, format: format, fps: fps)
    }

    func stopCapturing() {
        capturer.stopCapture()
    }
}
