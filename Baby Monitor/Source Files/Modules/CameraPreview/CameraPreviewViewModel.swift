//
//  CameraPreviewViewModel.swift
//  Baby Monitor
//

import RxSwift
import WebRTC

final class CameraPreviewViewModel {

    private let babyRepo: BabiesRepositoryProtocol
    lazy var baby: Observable<Baby> = babyRepo.babyUpdateObservable
    private let webRtcClientManager: WebRtcClientManagerProtocol
    private let webSocket: WebSocketProtocol?
    private let decoders: [AnyMessageDecoder<WebRtcMessage>]
    private let bag = DisposeBag()
    var remoteStream: Observable<MediaStreamProtocol> {
        return webRtcClientManager.mediaStream
    }

    init(webRtcClientManager: WebRtcClientManagerProtocol, webSocket: WebSocketProtocol?, babyRepo: BabiesRepositoryProtocol, decoders: [AnyMessageDecoder<WebRtcMessage>]) {
        self.webRtcClientManager = webRtcClientManager
        self.webSocket = webSocket
        self.babyRepo = babyRepo
        self.decoders = decoders
        setup()
    }

    deinit {
        webRtcClientManager.disconnect()
        webSocket?.close()
    }

    // MARK: - Coordinator callback
    var didSelectShowBabies: (() -> Void)?
    var didSelectCancel: (() -> Void)?

    private func setup() {
        Observable.merge(sdpOfferJson(), iceCandidateJson())
            .subscribe(onNext: { [weak self] json in
                self?.webSocket?.send(message: json)
            })
            .disposed(by: bag)
        webSocket?.decodedMessage(using: decoders)
            .subscribe(onNext: { [unowned self] message in
                guard let message = message else {
                    return
                }
                self.handle(message: message)
            })
            .disposed(by: bag)
    }

    private func sdpOfferJson() -> Observable<String> {
        return webRtcClientManager.sdpOffer
            .flatMap { sdp -> Observable<String> in
                let json = [WebRtcMessage.Key.offerSDP.rawValue: sdp.jsonDictionary()]
                guard let jsonString = json.jsonString else {
                    return Observable.empty()
                }
                return Observable.just(jsonString)
            }
    }

    private func iceCandidateJson() -> Observable<String> {
        return webRtcClientManager.iceCandidate
            .flatMap { iceCandidate -> Observable<String> in
                let json = [WebRtcMessage.Key.iceCandidate.rawValue: iceCandidate.jsonDictionary()]
                guard let jsonString = json.jsonString else {
                    return Observable.empty()
                }
                return Observable.just(jsonString)
            }
    }
    
    private func handle(message: WebRtcMessage) {
        switch message {
        case .sdpAnswer(let sdp):
            webRtcClientManager.setAnswerSDP(sdp: sdp)
        case .iceCandidate(let candidate):
            webRtcClientManager.setICECandidates(iceCandidate: candidate)
        default:
            break
        }
    }
    
    // MARK: - Internal functions
    func selectCancel() {
        didSelectCancel?()
    }

    func play() {
        webSocket?.open()
        webRtcClientManager.startWebRtcConnection()
    }

    func selectShowBabies() {
        didSelectShowBabies?()
    }
}
