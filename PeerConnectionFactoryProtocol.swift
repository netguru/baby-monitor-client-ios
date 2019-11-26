//
//  PeerConnectionFactoryProtocol.swift
//  Baby Monitor
//

import AVKit
import WebRTC

protocol PeerConnectionFactoryProtocol {
    func peerConnection(with delegate: RTCPeerConnectionDelegate) -> PeerConnectionProtocol
    func createStream() -> (VideoCapturer?, MediaStream?)
}

protocol VideoCapturer {
    func resumeCapturing()
    func stopCapturing()
}

struct WebRTCVideoCapturer: VideoCapturer {

    let device: AVCaptureDevice
    let format: AVCaptureDevice.Format
    let fps: Int
    let capturer: RTCCameraVideoCapturer

    func resumeCapturing() {
        capturer.startCapture(with: device, format: format, fps: fps)
    }

    func stopCapturing() {
        capturer.stopCapture()
    }
}

extension RTCPeerConnectionFactory: PeerConnectionFactoryProtocol {

    func peerConnection(with delegate: RTCPeerConnectionDelegate) -> PeerConnectionProtocol {
        let config = RTCConfiguration()
        config.iceServers = []
        config.sdpSemantics = .unifiedPlan

        // gatherContinually will let WebRTC to listen to any network changes and send any new candidates to the other client
        config.continualGatheringPolicy = .gatherContinually
        return peerConnection(with: config, constraints: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: ["DtlsSrtpKeyAgreement": "true"]), delegate: delegate)
    }

    func createStream() -> (VideoCapturer?, MediaStream?) {
        let localStream = mediaStream(withStreamId: "ARDAMS")

        let vSource = videoSource()

        let devices = RTCCameraVideoCapturer.captureDevices()
        if let camera = devices.first,
            let format = RTCCameraVideoCapturer.supportedFormats(for: camera).last,
            let fps = format.videoSupportedFrameRateRanges.first?.maxFrameRate {
            let intFps = Int(fps)
            let capturer = RTCCameraVideoCapturer(delegate: vSource)
            let videoCapturer = WebRTCVideoCapturer(device: camera, format: format, fps: intFps, capturer: capturer)
            capturer.startCapture(with: camera, format: format, fps: intFps)
            let vTrack = videoTrack(with: vSource, trackId: "ARDAMSv0")
            localStream.addVideoTrack(vTrack)

            let aTrack = audioTrack(withTrackId: "ARDAMSa0")
            localStream.addAudioTrack(aTrack)

            return (videoCapturer, localStream)
        }
        return (nil, nil)
    }
}
