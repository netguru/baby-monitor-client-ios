//
//  WebRtcServerManagerMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import RxSwift

final class WebRtcServerManagerMock: WebRtcServerManagerProtocol {
    private(set) var isStarted = true
    private(set) var remoteSdp: SessionDescriptionProtocol?
    private(set) var iceCandidates = [IceCandidateProtocol]()
    private(set) var isSetup = false

    private let localSdp: SessionDescriptionProtocol?

    init(sdpAnswer: SessionDescriptionProtocol? = nil) {
        self.localSdp = sdpAnswer
    }

    func start() {
        isSetup = true
    }

    func createAnswer(remoteSdp: SessionDescriptionProtocol) {
        self.remoteSdp = remoteSdp
        guard let localSdp = localSdp else {
            return
        }
        sdpAnswerPublisher.onNext(localSdp)
    }

    func setICECandidates(iceCandidate: IceCandidateProtocol) {
        iceCandidates.append(iceCandidate)
    }

    func disconnect() {
        isStarted = false
    }

    var sdpAnswer: Observable<SessionDescriptionProtocol> {
        return sdpAnswerPublisher
    }
    let sdpAnswerPublisher = PublishSubject<SessionDescriptionProtocol>()

    var iceCandidate: Observable<IceCandidateProtocol> {
        return iceCandidatePublisher
    }
    let iceCandidatePublisher = PublishSubject<IceCandidateProtocol>()

    var mediaStream: Observable<MediaStream> {
        return mediaStreamPublisher
    }
    let mediaStreamPublisher = PublishSubject<MediaStream>()
}
