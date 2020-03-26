//
//  WebSocketWebRtcService.swift
//  Baby Monitor
//

import RxSwift

protocol WebSocketWebRtcServiceProtocol: AnyObject, WebSocketConnectionStatusProvider {
    var mediaStream: Observable<WebRTCMediaStream?> { get }
    func start()
    func close()
    func closeWebRtcConnection()
    func startAudioTransmitting()
    func stopAudioTransmitting()
}

final class WebSocketWebRtcService: WebSocketWebRtcServiceProtocol {

    lazy var mediaStream: Observable<WebRTCMediaStream?> = webRtcClientManager.mediaStream
    
    var connectionStatusObservable: Observable<WebSocketConnectionStatus> {
        webRtcClientManager.connectionStatusObservable
    }

    private let webRtcClientManager: WebRtcClientManagerProtocol
    private var webSocketConductor: WebSocketConductorProtocol?

    init(webRtcClientManager: WebRtcClientManagerProtocol, webSocketConductorFactory: (Observable<String>, AnyObserver<WebRtcMessage>) -> WebSocketConductorProtocol) {
        self.webRtcClientManager = webRtcClientManager
        setupWebRtcConductor(with: webSocketConductorFactory)
    }

    private func setupWebRtcConductor(with factory: (Observable<String>, AnyObserver<WebRtcMessage>) -> WebSocketConductorProtocol) {
        webSocketConductor = factory(Observable.merge(sdpOfferJson(), iceCandidateJson()), webRtcMessageHandler())
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

    private func webRtcMessageHandler() -> AnyObserver<WebRtcMessage> {
        return AnyObserver<WebRtcMessage>(eventHandler: { [weak self] event in
            guard let message = event.element else {
                return
            }
            switch message {
            case .sdpAnswer(let sdp):
                self?.webRtcClientManager.setAnswerSDP(sdp: sdp)
            case .iceCandidate(let candidate):
                self?.webRtcClientManager.setICECandidates(iceCandidate: candidate)
            default:
                break
            }
        })
    }

    func start() {
        webSocketConductor?.open()
        webRtcClientManager.startIfNeeded()
    }
    
    func close() {
        webSocketConductor?.close()
        webRtcClientManager.stop()
    }
    
    func closeWebRtcConnection() {
        webRtcClientManager.stop()
    }

    func startAudioTransmitting() {
        webRtcClientManager.enableAudioTrack()
    }
    
    func stopAudioTransmitting() {
        webRtcClientManager.disableAudioTrack()
    }
}
