//
//  PeerConnectionFactoryProtocol.swift
//  Baby Monitor
//

import AVKit

protocol PeerConnectionFactoryProtocol {
    func peerConnection(with delegate: RTCPeerConnectionDelegate) -> PeerConnectionProtocol
    func createStream() -> MediaStream?
}

typealias VideoCapturer = AnyObject

extension RTCPeerConnectionFactory: PeerConnectionFactoryProtocol {

    func peerConnection(with delegate: RTCPeerConnectionDelegate) -> PeerConnectionProtocol {
        return peerConnection(withICEServers: [], constraints: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: [RTCPair(key: "DtlsSrtpKeyAgreement", value: "true")]), delegate: delegate)
    }

    func createStream() -> MediaStream? {

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) else { return nil }
        guard let videoCapturer = RTCVideoCapturer(deviceName: device.localizedName) else { return nil }
        guard let localStream = mediaStream(withLabel: "ARDAMS") else { return nil }

        let vTrack = videoTrack(withID: "ARDAMSv0", source: videoSource(with: videoCapturer, constraints: nil))
        localStream.addVideoTrack(vTrack)

        let aTrack = audioTrack(withID: "ARDAMSa0")
        localStream.addAudioTrack(aTrack)

        return localStream

    }

}
