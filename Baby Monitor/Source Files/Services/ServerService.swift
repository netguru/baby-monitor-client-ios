//
//  ServerService.swift
//  Baby Monitor
//

import Foundation
import RxSwift

protocol ServerServiceProtocol: AnyObject {
    var localStreamObservable: Observable<MediaStream> { get }
    var audioMicrophoneServiceErrorObservable: Observable<Void> { get }
    var remoteResetEventObservable: Observable<Void> { get }
    func startStreaming()
    func stop()
}

final class ServerService: ServerServiceProtocol {
    
    var localStreamObservable: Observable<MediaStream> {
        return webRtcServerManager.mediaStream
    }
    lazy var audioMicrophoneServiceErrorObservable = audioMicrophoneServiceErrorPublisher.asObservable()
    lazy var remoteResetEventObservable = remoteResetEventPublisher.asObservable()
    
    private let parentResponseTime: TimeInterval
    private let webRtcServerManager: WebRtcServerManagerProtocol
    private let messageServer: MessageServerProtocol
    private let netServiceServer: NetServiceServerProtocol
    private let cryingEventService: CryingEventsServiceProtocol
    private let babyModelController: BabyModelControllerProtocol
    private let disposeBag = DisposeBag()
    private let decoders: [AnyMessageDecoder<WebRtcMessage>]
    private let notificationsService: NotificationServiceProtocol
    private let audioMicrophoneServiceErrorPublisher = PublishSubject<Void>()
    private let remoteResetEventPublisher = PublishSubject<Void>()
    private let babyMonitorEventMessagesDecoder: AnyMessageDecoder<EventMessage>
    
    init(webRtcServerManager: WebRtcServerManagerProtocol, messageServer: MessageServerProtocol, netServiceServer: NetServiceServerProtocol, webRtcDecoders: [AnyMessageDecoder<WebRtcMessage>], cryingService: CryingEventsServiceProtocol, babyModelController: BabyModelControllerProtocol, notificationsService: NotificationServiceProtocol, babyMonitorEventMessagesDecoder: AnyMessageDecoder<EventMessage>, parentResponseTime: TimeInterval = 5.0) {
        self.cryingEventService = cryingService
        self.babyModelController = babyModelController
        self.webRtcServerManager = webRtcServerManager
        self.messageServer = messageServer
        self.netServiceServer = netServiceServer
        self.decoders = webRtcDecoders
        self.notificationsService = notificationsService
        self.babyMonitorEventMessagesDecoder = babyMonitorEventMessagesDecoder
        self.parentResponseTime = parentResponseTime
        rxSetup()
    }
    
    func stop() {
        netServiceServer.isEnabled.value = false
        messageServer.stop()
        webRtcServerManager.stop()
        cryingEventService.stop()
    }
    
    private func rxSetup() {
        cryingEventService.cryingEventObservable
            .throttle(Constants.notificationRequestTimeLimit, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.notificationsService.sendPushNotificationsRequest()
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
        Observable.merge(sdpAnswerJson())
            .subscribe(onNext: { [unowned self] json in
                self.messageServer.send(message: json)
            })
            .disposed(by: disposeBag)
    }
    
    private func handle(message: WebRtcMessage) {
        switch message {
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
        case .pushNotificationsKey:
            UserDefaults.receiverPushNotificationsToken = event.value
        case .resetKey:
            remoteResetEventPublisher.onNext(())
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
    
    /// Starts streaming
    func startStreaming() {
        messageServer.start()
        netServiceServer.isEnabled.value = true
        do {
            try cryingEventService.start()
        } catch {
            switch error {
            case CryingEventService.CryingEventServiceError.audioRecordServiceError:
                audioMicrophoneServiceErrorPublisher.onNext(())
            default:
                break
            }
        }
        webRtcServerManager.start()
    }
}
