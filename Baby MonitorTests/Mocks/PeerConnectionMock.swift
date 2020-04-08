//
//  PeerConnectionMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import WebRTC

final class PeerConnectionMock: PeerConnectionProtocol {

    var shouldSetRemoteDescriptionFail = false
    private(set) var isConnected = true
    private(set) var remoteSdp: SessionDescriptionProtocol?
    private(set) var localSdp: SessionDescriptionProtocol?
    private(set) var iceCandidates = [IceCandidateProtocol]()
    private(set) var mediaStream: WebRTCMediaStream?

    private let offerSdp: SessionDescriptionProtocol?
    private let answerSdp: SessionDescriptionProtocol?
    private let error: Error?

    init(offerSdp: SessionDescriptionProtocol? = nil, answerSdp: SessionDescriptionProtocol? = nil, error: Error? = nil) {
        self.offerSdp = offerSdp
        self.answerSdp = answerSdp
        self.error = error
    }

    func setRemoteDescription(sdp: SessionDescriptionProtocol, handler: ((Error?) -> Void)?) {
        if shouldSetRemoteDescriptionFail {
            handler?(NSError(domain: "domain", code: 0, userInfo: nil))
        } else {
            self.remoteSdp = sdp
            handler?(nil)
        }
    }

    func setLocalDescription(sdp: SessionDescriptionProtocol, handler: ((Error?) -> Void)?) {
        self.localSdp = sdp
        handler?(nil)
    }

    func add(iceCandidate: IceCandidateProtocol) {
        iceCandidates.append(iceCandidate)
    }

    func add(stream: WebRTCMediaStream) {
        self.mediaStream = stream
    }

    func close() {
        isConnected = false
    }

    func createOffer(for constraints: MediaConstraints, handler: ((RTCSessionDescription?, Error?) -> Void)?) {
        guard let sdp = offerSdp?.sdp,
            let type = offerSdp.flatMap( { RTCSdpType.type(for: $0.stringType) }) else  {
                handler?(nil, error)
                return
        }
        handler?(RTCSessionDescription(type: type, sdp: sdp), error)
    }

    func createAnswer(for constraints: MediaConstraints, handler: ((RTCSessionDescription?, Error?) -> Void)?) {
        guard let sdp = answerSdp?.sdp,
            let type = answerSdp.flatMap( { RTCSdpType.type(for: $0.stringType) }) else  {
                handler?(nil, error)
                return
        }
        handler?(RTCSessionDescription(type: type, sdp: sdp), error)
    }
}
