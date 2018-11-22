//
//  StreamFactoryProtocol.swift
//  Baby Monitor
//

import WebRTC

protocol StreamFactoryProtocol {
    func createStream() -> MediaStreamProtocol
}

extension RTCPeerConnectionFactory: StreamFactoryProtocol {
    func createStream() -> MediaStreamProtocol {
        let videoSource = self.videoSource()
        let videoTrack = self.videoTrack(with: videoSource, trackId: WebRtcStreamId.videoTrack.rawValue)
        let localStream = mediaStream(withStreamId: WebRtcStreamId.mediaStream.rawValue)
        let audioTrack = self.audioTrack(withTrackId: WebRtcStreamId.audioTrack.rawValue)
        localStream.addVideoTrack(videoTrack)
        localStream.addAudioTrack(audioTrack)
        return localStream
    }
}
