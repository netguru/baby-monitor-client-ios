//
//  PeerConnectionFactoryProtocol.swift
//  Baby Monitor
//

import AVKit

protocol PeerConnectionFactoryProtocol {
    func peerConnection(with delegate: RTCPeerConnectionDelegate) -> PeerConnectionProtocol
    func createStream(handler: (MediaStream, VideoCapturer) -> Void)
}

typealias VideoCapturer = AnyObject

extension RTCPeerConnectionFactory: PeerConnectionFactoryProtocol {
    func peerConnection(with delegate: RTCPeerConnectionDelegate) -> PeerConnectionProtocol {
        return peerConnection(withICEServers: [], constraints: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: [RTCPair(key: "DtlsSrtpKeyAgreement", value: "true")]), delegate: delegate)
    }

    func createStream(handler: (MediaStream, VideoCapturer) -> Void) {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) else {
            return
        }
        let cameraID = device.localizedName
        guard let videoCapturer = RTCVideoCapturer(deviceName: cameraID) else {
            return
        }
        let videoSource = self.videoSource(with: videoCapturer, constraints: nil)
        let videoTrack = self.videoTrack(withID: "ARDAMSv0", source: videoSource)
        guard let localStream = mediaStream(withLabel: "ARDAMS") else {
            return
        }
        let audioTrack = self.audioTrack(withID: "ARDAMSa0")
        localStream.addVideoTrack(videoTrack)
        localStream.addAudioTrack(audioTrack)
        handler(localStream, videoCapturer)
    }
}
