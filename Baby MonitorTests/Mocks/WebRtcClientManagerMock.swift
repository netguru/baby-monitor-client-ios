//
//  WebRtcClientManagerMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import RxSwift

final class WebRtcClientManagerMock: WebRtcClientManagerProtocol {

    private(set) var isStarted = false
    private(set) var remoteSdp: SessionDescriptionProtocol?

    private let localSdp: SessionDescriptionProtocol?

    init(sdpOffer: SessionDescriptionProtocol? = nil) {
        self.localSdp = sdpOffer
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

    func stop() {
        isStarted = false
    }

    var sdpOffer: Observable<SessionDescriptionProtocol> {
        return sdpOfferPublisher
    }
    let sdpOfferPublisher = PublishSubject<SessionDescriptionProtocol>()

    var mediaStream: Observable<MediaStream?> {
        return mediaStreamPublisher
    }
    let mediaStreamPublisher = PublishSubject<MediaStream?>()

    var state: Observable<WebRtcClientManagerState> {
        return statePublisher
    }
    let statePublisher = PublishSubject<WebRtcClientManagerState>()
}
