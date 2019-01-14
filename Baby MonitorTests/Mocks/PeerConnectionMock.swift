//
//  PeerConnectionMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

final class PeerConnectionMock: PeerConnectionProtocol {

    private(set) var isConnected = true
    private(set) var remoteSdp: SessionDescriptionProtocol?
    private(set) var localSdp: SessionDescriptionProtocol?
    private(set) var iceCandidates = [IceCandidateProtocol]()
    private(set) var mediaStream: MediaStream?

    private let offerSdp: SessionDescriptionProtocol?
    private let answerSdp: SessionDescriptionProtocol?
    private let error: Error?

    init(offerSdp: SessionDescriptionProtocol? = nil, answerSdp: SessionDescriptionProtocol? = nil, error: Error? = nil) {
        self.offerSdp = offerSdp
        self.answerSdp = answerSdp
        self.error = error
    }

    func setRemoteDescription(sdp: SessionDescriptionProtocol, delegate: RTCSessionDescriptionDelegate) {
        self.remoteSdp = sdp
    }

    func setLocalDescription(sdp: SessionDescriptionProtocol, delegate: RTCSessionDescriptionDelegate) {
        self.localSdp = sdp
    }

    func add(iceCandidate: IceCandidateProtocol) {
        iceCandidates.append(iceCandidate)
    }

    func add(stream: MediaStream) {
        self.mediaStream = stream
    }

    func close() {
        isConnected = false
    }

    func createOffer(for constraints: MediaConstraints, delegate: RTCSessionDescriptionDelegate) {
        delegate.peerConnection(nil, didCreateSessionDescription: RTCSessionDescription(type: offerSdp?.stringType, sdp: offerSdp?.sdp), error: error)
    }

    func createAnswer(for constraints: MediaConstraints, delegate: RTCSessionDescriptionDelegate) {
        delegate.peerConnection(nil, didCreateSessionDescription: RTCSessionDescription(type: offerSdp?.stringType, sdp: offerSdp?.sdp), error: error)
    }
}
