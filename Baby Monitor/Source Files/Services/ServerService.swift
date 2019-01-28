//
//  ServerService.swift
//  Baby Monitor
//

import Foundation
import RxSwift

protocol ServerServiceProtocol: AnyObject {
    var localStreamObservable: Observable<MediaStream> { get }
    var audioRecordServiceErrorObservable: Observable<Void> { get }
    func startStreaming()
}

final class ServerService: ServerServiceProtocol {
    
    var localStreamObservable: Observable<MediaStream> {
        return webRtcServerManager.mediaStream
    }
    lazy var audioRecordServiceErrorObservable = audioRecordServiceErrorPublisher.asObservable()
    
    private var isCryingMessageReceivedFromClient = false
    private var timer: Timer?
    private let parentResponseTime: TimeInterval
    private let webRtcServerManager: WebRtcServerManagerProtocol
    private let messageServer: MessageServerProtocol
    private let netServiceServer: NetServiceServerProtocol
    private let cryingEventService: CryingEventsServiceProtocol
    private let babyModelController: BabyModelControllerProtocol
    private let cacheService: CacheServiceProtocol
    private let disposeBag = DisposeBag()
    private let decoders: [AnyMessageDecoder<WebRtcMessage>]
    private let notificationsService: NotificationServiceProtocol
    private let audioRecordServiceErrorPublisher = PublishSubject<Void>()
    private let babyMonitorEventMessagesDecoder: AnyMessageDecoder<EventMessage>
    
    init(webRtcServerManager: WebRtcServerManagerProtocol, messageServer: MessageServerProtocol, netServiceServer: NetServiceServerProtocol, webRtcDecoders: [AnyMessageDecoder<WebRtcMessage>], cryingService: CryingEventsServiceProtocol, babyModelController: BabyModelControllerProtocol, cacheService: CacheServiceProtocol, notificationsService: NotificationServiceProtocol, babyMonitorEventMessagesDecoder: AnyMessageDecoder<EventMessage>, parentResponseTime: TimeInterval = 5.0) {
        self.cryingEventService = cryingService
        self.babyModelController = babyModelController
        self.webRtcServerManager = webRtcServerManager
        self.messageServer = messageServer
        self.netServiceServer = netServiceServer
        self.cacheService = cacheService
        self.decoders = webRtcDecoders
        self.notificationsService = notificationsService
        self.babyMonitorEventMessagesDecoder = babyMonitorEventMessagesDecoder
        self.parentResponseTime = parentResponseTime
        rxSetup()
    }
    
    func stop() {
        netServiceServer.stop()
        messageServer.stop()
        webRtcServerManager.disconnect()
        cryingEventService.stop()
    }
    
    private func rxSetup() {
        cryingEventService.cryingEventObservable.subscribe(onNext: { [unowned self] cryingEventMessage in
            self.messageServer.send(message: cryingEventMessage.toStringMessage())
            self.timer = Timer.scheduledTimer(withTimeInterval: self.parentResponseTime, repeats: false, block: { _ in
                if !self.isCryingMessageReceivedFromClient {
                    self.notificationsService.sendPushNotificationsRequest()
                }
                self.isCryingMessageReceivedFromClient = false
            })
        }).disposed(by: disposeBag)
        messageServer.decodedMessage(using: decoders)
            .subscribe(onNext: { [unowned self] message in
                guard let message = message else {
                    return
                }
                self.handle(message: message)
            })
            .disposed(by: disposeBag)
        messageServer.decodedMessage(using: [babyMonitorEventMessagesDecoder]).subscribe(onNext: { [unowned self] event in
            guard let event = event else {
                return
            }
            self.handle(event: event)
        })
            .disposed(by: disposeBag)
        Observable.merge(sdpAnswerJson(), iceCandidateJson())
            .subscribe(onNext: { [unowned self] json in
                self.messageServer.send(message: json)
            })
            .disposed(by: disposeBag)
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
    
    private func handle(event: EventMessage) {
        guard let babyMonitorEvent = BabyMonitorEvent(rawValue: event.action) else {
            return
        }
        switch babyMonitorEvent {
        case .cryingEventMessageReceived:
            isCryingMessageReceivedFromClient = true
        case .pushNotificationsKey:
            self.cacheService.receiverPushNotificationsToken = event.value
        case .crying:
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
                audioRecordServiceErrorPublisher.onNext(())
            default:
                break
            }
        }
        webRtcServerManager.start()
    }
}
