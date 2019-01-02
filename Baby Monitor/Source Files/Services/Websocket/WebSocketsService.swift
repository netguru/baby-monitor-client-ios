//
//  WebSocketsService.swift
//  Baby Monitor
//

import Foundation
import RxSwift

protocol WebSocketsServiceProtocol: AnyObject {
    var onCryingEventOccurence: (() -> Void)? { get set }
    
    /// Open websockets connection
    func play()
    
    var mediaStream: Observable<RTCMediaStream> { get }
    
    // TODO: Stop
}

final class WebSocketsService: WebSocketsServiceProtocol {
    var mediaStream: Observable<RTCMediaStream> {
        return webRtcClientManager.mediaStream
    }
    
    var onCryingEventOccurence: (() -> Void)?
    
    private let webRtcClientManager: WebRtcClientManagerProtocol
    private let webSocket: WebSocketProtocol?
    private let webRtcMessageDecoders: [AnyMessageDecoder<WebRtcMessage>]
    private let babyMonitorEventMessagesDecoder: AnyMessageDecoder<EventMessage>
    private let bag = DisposeBag()
    private let cryingEventsRepository: CryingEventsRepositoryProtocol
    
    init(webRtcClientManager: WebRtcClientManagerProtocol, webSocket: WebSocketProtocol?, cryingEventsRepository: CryingEventsRepositoryProtocol, webRtcMessageDecoders: [AnyMessageDecoder<WebRtcMessage>], babyMonitorEventMessagesDecoder: AnyMessageDecoder<EventMessage>) {
        self.webRtcClientManager = webRtcClientManager
        self.webSocket = webSocket
        self.cryingEventsRepository = cryingEventsRepository
        self.webRtcMessageDecoders = webRtcMessageDecoders
        self.babyMonitorEventMessagesDecoder = babyMonitorEventMessagesDecoder
        setup()
    }
    
    func play() {
        webSocket?.open()
        webRtcClientManager.startWebRtcConnection()
    }
    
    private func setup() {
        Observable.merge(sdpOfferJson(), iceCandidateJson())
            .subscribe(onNext: { [weak self] json in
                self?.webSocket?.send(message: json)
            })
            .disposed(by: bag)
        webSocket?.decodedMessage(using: webRtcMessageDecoders)
            .subscribe(onNext: { [unowned self] message in
                guard let message = message else {
                    return
                }
                self.handle(message: message)
            })
            .disposed(by: bag)
        webSocket?.decodedMessage(using: [babyMonitorEventMessagesDecoder])
            .subscribe(onNext: { [unowned self] event in
                guard let event = event else {
                    return
                }
                self.handle(event: event)
            }).disposed(by: bag)
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
    
    private func handle(event: EventMessage) {
        guard let babyEvent = BabyMonitorEvent(rawValue: event.action) else {
            return
        }
        switch babyEvent {
        case .crying:
            cryingEventsRepository.save(cryingEvent: CryingEvent(fileName: event.value))
            onCryingEventOccurence?()
        }
    }
}
