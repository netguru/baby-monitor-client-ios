//
//  ServerViewModel.swift
//  Baby Monitor
//

import Foundation
import WebRTC
import RxSwift

final class ServerViewModel {
    
    private let webRtcServerManager: WebRtcServerManagerProtocol
    private let messageServer: MessageServerProtocol
    private let netServiceServer: NetServiceServerProtocol
    var localStream: Observable<MediaStreamProtocol> {
        return webRtcServerManager.mediaStream
    }
    var onAudioRecordServiceError: (() -> Void)?
    private let cryingEventService: CryingEventsServiceProtocol
    private let babiesRepository: BabiesRepositoryProtocol
    
    private let bag = DisposeBag()
    
    private let decoders: [AnyMessageDecoder<WebRtcMessage>]
    
    init(webRtcServerManager: WebRtcServerManagerProtocol, messageServer: MessageServerProtocol, netServiceServer: NetServiceServerProtocol, decoders: [AnyMessageDecoder<WebRtcMessage>], cryingService: CryingEventsServiceProtocol, babiesRepository: BabiesRepositoryProtocol) {
        self.cryingEventService = cryingService
        self.babiesRepository = babiesRepository
        self.webRtcServerManager = webRtcServerManager
        self.messageServer = messageServer
        self.netServiceServer = netServiceServer
        self.decoders = decoders
        setup()
        rxSetup()
    }
    
    private func setup() {
        if babiesRepository.getCurrent() == nil {
            let baby = Baby(name: "Anonymous")
            try! babiesRepository.save(baby: baby)
            babiesRepository.setCurrent(baby: baby)
        }
    }
    
    private func rxSetup() {
        cryingEventService.cryingEventObservable.subscribe(onNext: { [weak self] cryingEventMessage in
                let jsonString = try! JSONEncoder().encode(cryingEventMessage).base64EncodedString()
                self?.messageServer.send(message: jsonString)
        }).disposed(by: bag)
        messageServer.decodedMessage(using: decoders)
            .subscribe(onNext: { [unowned self] message in
                guard let message = message else {
                    return
                }
                self.handle(message: message)
            })
            .disposed(by: bag)
        Observable.merge(sdpAnswerJson(), iceCandidateJson())
            .subscribe(onNext: { [unowned self] json in
                self.messageServer.send(message: json)
            })
            .disposed(by: bag)
    }
    
    private func handle(message: WebRtcMessage) {
        switch message {
        case .iceCandidate(let iceCandidate):
            webRtcServerManager.setICECandidates(iceCandidate: iceCandidate)
        case .sdpOffer(let sdp):
            webRtcServerManager.createAnswer(remoteSdp: sdp)
        default:
            break
        }
    }
    
    private func sdpAnswerJson() -> Observable<String> {
        return webRtcServerManager.sdpAnswer
            .flatMap { sdp -> Observable<String> in
                let json = [WebRtcMessage.Key.answerSDP.rawValue: sdp.jsonDictionary()]
                guard let jsonString = json.jsonString else {
                    return Observable.empty()
                }
                return Observable.just(jsonString)
            }
    }
    
    private func iceCandidateJson() -> Observable<String> {
        return webRtcServerManager.iceCandidate
            .flatMap { iceCandidate -> Observable<String> in
                let json = [WebRtcMessage.Key.iceCandidate.rawValue: iceCandidate.jsonDictionary()]
                guard let jsonString = json.jsonString else {
                    return Observable.empty()
                }
                return Observable.just(jsonString)
            }
    }
    
    /// Starts streaming
    func startStreaming() {
        messageServer.start()
        netServiceServer.publish()
        do {
            try cryingEventService.start()
        } catch {
            switch error {
            case CryingEventService.CryingEventServiceError.audioRecordServiceError:
                onAudioRecordServiceError?()
            default:
                break
            }
        }
    }
    
    deinit {
        netServiceServer.stop()
        messageServer.stop()
        webRtcServerManager.disconnect()
        cryingEventService.stop()
    }
}
