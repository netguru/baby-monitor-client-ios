//
//  PeerConnectionFactoryProtocol.swift
//  Baby Monitor
//

import AVKit

protocol PeerConnectionFactoryProtocol {
    func peerConnection(with delegate: RTCPeerConnectionDelegate) -> PeerConnectionProtocol
    func createStream(_ handler: (MediaStream) -> Void)
}

typealias VideoCapturer = AnyObject

extension RTCPeerConnectionFactory: PeerConnectionFactoryProtocol {

    func peerConnection(with delegate: RTCPeerConnectionDelegate) -> PeerConnectionProtocol {
        return peerConnection(withICEServers: [], constraints: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: [RTCPair(key: "DtlsSrtpKeyAgreement", value: "true")]), delegate: delegate)
    }

    func createStream(_ handler: (MediaStream) -> Void) {

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) else { return }
        guard let videoCapturer = RTCVideoCapturer(deviceName: device.localizedName) else { return }
        guard let localStream = mediaStream(withLabel: "ARDAMS") else { return }

        let vTrack = videoTrack(withID: "ARDAMSv0", source: videoSource(with: videoCapturer, constraints: nil))
        localStream.addVideoTrack(vTrack)

        let aTrack = audioTrack(withID: "ARDAMSa0")
        localStream.addAudioTrack(aTrack)

        handler(localStream)

    }

}
