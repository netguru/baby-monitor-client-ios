//
//  WebRtcClientManagerMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import RxSwift
import WebRTC

final class WebRtcClientManagerMock: WebRtcClientManagerProtocol {

    private(set) var isStarted = false
    private(set) var remoteSdp: SessionDescriptionProtocol?
    private(set) var iceCandidates = [IceCandidateProtocol]()

    private let localSdp: SessionDescriptionProtocol?

    init(sdpOffer: SessionDescriptionProtocol? = nil) {
        self.localSdp = sdpOffer
    }

    func startWebRtcConnection() {
        isStarted = true
        guard let localSdp = localSdp else {
            return
        }
        sdpOfferPublisher.onNext(localSdp)
    }

    func setAnswerSDP(sdp: SessionDescriptionProtocol) {
        remoteSdp = sdp
    }

    func setICECandidates(iceCandidate: IceCandidateProtocol) {
        iceCandidates.append(iceCandidate)
    }

    func disconnect() {
        isStarted = false
    }

    var sdpOffer: Observable<SessionDescriptionProtocol> {
        return sdpOfferPublisher
    }
    let sdpOfferPublisher = PublishSubject<SessionDescriptionProtocol>()

    var iceCandidate: Observable<IceCandidateProtocol> {
        return iceCandidatePublisher
    }
    let iceCandidatePublisher = PublishSubject<IceCandidateProtocol>()

    var mediaStream: Observable<RTCMediaStream> {
        return mediaStreamPublisher
    }
    let mediaStreamPublisher = PublishSubject<RTCMediaStream>()
}
