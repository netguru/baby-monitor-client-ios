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
            let videoCapturer = WebRTCVideoCapturer(device: camera, format: format, framesPerSecond: intFps, capturer: capturer)
            videoCapturer.resumeCapturing()
            let vTrack = videoTrack(with: vSource, trackId: "ARDAMSv0")
            localStream.addVideoTrack(vTrack)

            let aTrack = audioTrack(withTrackId: "ARDAMSa0")
            localStream.addAudioTrack(aTrack)

            return (videoCapturer, localStream)
        }
        return (nil, nil)
    }
}
