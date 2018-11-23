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
    private let error: Error?

    init(offerSdp: SessionDescriptionProtocol? = nil, error: Error? = nil) {
        self.offerSdp = offerSdp
        self.error = error
    }

    func setRemoteDescription(sdp: SessionDescriptionProtocol, completionHandler: ((Error?) -> Void)?) {
        self.remoteSdp = sdp
    }

    func setLocalDescription(sdp: SessionDescriptionProtocol, completionHandler: ((Error?) -> Void)?) {
        self.localSdp = sdp
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
}
