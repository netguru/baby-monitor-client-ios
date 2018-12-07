//
//  StreamFactoryProtocol.swift
//  Baby Monitor
//

import WebRTC

protocol StreamFactoryProtocol {
    func createStream(handler: @escaping (Error) -> Void) -> (RTCVideoCapturer?, MediaStreamProtocol?)
}

extension RTCPeerConnectionFactory: StreamFactoryProtocol {
    func createStream(handler: @escaping (Error) -> Void) -> (RTCVideoCapturer?, MediaStreamProtocol?) {
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)!
        let videoSource = self.videoSource()
        let capturer = RTCCameraVideoCapturer(delegate: videoSource)
        capturer.startCapture(with: captureDevice, format: captureDevice.activeFormat, fps: 10) { error in
            handler(error)
        }
        let videoTrack = self.videoTrack(with: videoSource, trackId: WebRtcStreamId.videoTrack.rawValue)
        let localStream = mediaStream(withStreamId: WebRtcStreamId.mediaStream.rawValue)
        let audioTrack = self.audioTrack(withTrackId: WebRtcStreamId.audioTrack.rawValue)
        localStream.addVideoTrack(videoTrack)
        localStream.addAudioTrack(audioTrack)
        return (capturer, localStream)
    }
}
