//
//  StreamFactoryProtocol.swift
//  Baby Monitor
//

import Foundation
import AVFoundation

protocol StreamFactoryProtocol {
    func createStream(didCreateStream: (MediaStreamProtocol, VideoCapturer) -> Void)
}

typealias VideoCapturer = AnyObject

extension RTCPeerConnectionFactory: StreamFactoryProtocol {
    func createStream(didCreateStream: (MediaStreamProtocol, VideoCapturer) -> Void) {
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) else {
            return
        }
        let videoSource = self.videoSource()
        let capturer = RTCVideoCapturer(delegate: videoSource)
        // Putting nil as handler crashes - hence the empty handler
        capturer.startCapture(with: captureDevice, format: captureDevice.activeFormat, fps: 25) { _ in }
        let videoTrack = self.videoTrack(with: videoSource, trackId: WebRtcStreamId.videoTrack.rawValue)
        let localStream = mediaStream(withStreamId: WebRtcStreamId.mediaStream.rawValue)
        let audioTrack = self.audioTrack(withTrackId: WebRtcStreamId.audioTrack.rawValue)
        localStream.addVideoTrack(videoTrack)
        localStream.addAudioTrack(audioTrack)
        didCreateStream(localStream, capturer)
    }
}
