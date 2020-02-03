//
//  WebRtcClientManagerMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import RxSwift

final class WebRtcClientManagerMock: WebRtcClientManagerProtocol {

    private(set) var isStarted = false
    private(set) var remoteSdp: SessionDescriptionProtocol?
    private(set) var iceCandidates = [IceCandidateProtocol]()
    private(set) var connectionStatusObservable: Observable<WebSocketConnectionStatus>

    private let localSdp: SessionDescriptionProtocol?
    let statePublisher = PublishSubject<WebSocketConnectionStatus>()

    init(sdpOffer: SessionDescriptionProtocol? = nil) {
        self.localSdp = sdpOffer
        self.connectionStatusObservable = statePublisher.asObservable()
    }
    
    func startIfNeeded() {
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

    func stop() {
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

    var mediaStream: Observable<MediaStream?> {
        return mediaStreamPublisher
    }
    let mediaStreamPublisher = PublishSubject<MediaStream?>()
}
