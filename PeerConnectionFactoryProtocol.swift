//
//  PeerConnectionFactoryProtocol.swift
//  Baby Monitor
//

import AVKit
import WebRTC

protocol PeerConnectionFactoryProtocol {
    func peerConnection(with delegate: PeerConnectionProxy) -> PeerConnectionProtocol

    /// Creates a stream with audio and video source.
    func createStream() -> (VideoCapturer?, WebRTCMediaStream?)

    /// Creates stream with audio track.
    func createAudioStream() -> WebRTCMediaStream
}

extension RTCPeerConnectionFactory: PeerConnectionFactoryProtocol {

    func peerConnection(with delegate: PeerConnectionProxy) -> PeerConnectionProtocol {
        let config = RTCConfiguration()
        config.iceServers = []
        config.sdpSemantics = .unifiedPlan

        // gatherContinually will let WebRTC to listen to any network changes and send any new candidates to the other client
        config.continualGatheringPolicy = .gatherContinually
        return peerConnection(with: config, constraints: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: ["DtlsSrtpKeyAgreement": "true"]), delegate: delegate)
    }

    func createStream() -> (VideoCapturer?, WebRTCMediaStream?) {
        let localStream = mediaStream(withStreamId: WebRtcStreamId.mediaStream)

        let vSource = videoSource()

        let devices = RTCCameraVideoCapturer.captureDevices()
        if let camera = devices.first,
            let format = RTCCameraVideoCapturer.supportedFormats(for: camera).last,
            let fps = format.videoSupportedFrameRateRanges.first?.maxFrameRate {
            let intFps = Int(fps)
            let capturer = RTCCameraVideoCapturer(delegate: vSource)
            let videoCapturer = WebRTCVideoCapturer(device: camera, format: format, framesPerSecond: intFps, capturer: capturer)
            videoCapturer.startCapturing()
            // The next line is a fix for a stream freeze on iOS 13.
            vSource.adaptOutputFormat(toWidth: 640, height: 480, fps: 30)
            let vTrack = videoTrack(with: vSource, trackId: WebRtcStreamId.videoTrack)
            localStream.addVideoTrack(vTrack)

            let aTrack = audioTrack(withTrackId: WebRtcStreamId.audioTrack)
            localStream.addAudioTrack(aTrack)

            return (videoCapturer, localStream)
        }
        return (nil, nil)
    }

    func createAudioStream() -> WebRTCMediaStream {
        let localStream = mediaStream(withStreamId: WebRtcStreamId.mediaStream)
        let audioStreamSource = audioSource(with: nil)
        let audioStreamTrack = audioTrack(with: audioStreamSource, trackId: WebRtcStreamId.audioTrack)
        localStream.addAudioTrack(audioStreamTrack)
        return localStream
    }
}
