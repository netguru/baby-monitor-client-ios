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
    private(set) var mediaStream: MediaStreamProtocol?

    private let offerSdp: SessionDescriptionProtocol?
    private let answerSdp: SessionDescriptionProtocol?
    private let error: Error?

    init(offerSdp: SessionDescriptionProtocol? = nil, answerSdp: SessionDescriptionProtocol? = nil, error: Error? = nil) {
        self.offerSdp = offerSdp
        self.answerSdp = answerSdp
        self.error = error
    }

    func setRemoteDescription(sdp: SessionDescriptionProtocol, completionHandler: ((Error?) -> Void)?) {
        self.remoteSdp = sdp
        completionHandler?(error)
    }

    func setLocalDescription(sdp: SessionDescriptionProtocol, completionHandler: ((Error?) -> Void)?) {
        self.localSdp = sdp
        completionHandler?(error)
    }

    func add(_ iceCandidate: IceCandidateProtocol) {
        iceCandidates.append(iceCandidate)
    }

    func add(stream: MediaStreamProtocol) {
        self.mediaStream = stream
    }

    func close() {
        isConnected = false
    }

    func createOffer(for constraints: MediaConstraintsProtocol, completionHandler: ((SessionDescriptionProtocol?, Error?) -> Void)?) {
        completionHandler?(offerSdp, error)
    }

    func createAnswer(for constraints: MediaConstraintsProtocol, completionHandler: ((SessionDescriptionProtocol?, Error?) -> Void)?) {
        completionHandler?(answerSdp, error)
    }
}
