//
//  ClientService.swift
//  Baby Monitor
//

import Foundation
import RxSwift

protocol ClientServiceProtocol: AnyObject {
    
}

final class ClientService: ClientServiceProtocol {
    
    lazy var cryingEventObservable = cryingEventPublisher.asObservable()
    
    private let cryingEventPublisher = PublishSubject<Void>()
    private let websocketsService: WebSocketsServiceProtocol
    private let messageServer: MessageServerProtocol
    private let localNotificationService: NotificationServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(websocketsService: WebSocketsServiceProtocol, localNotificationService: NotificationServiceProtocol, messageServer: MessageServerProtocol) {
        self.websocketsService = websocketsService
        self.localNotificationService = localNotificationService
        self.messageServer = messageServer
        setup()
    }
    
    private func setup() {
        websocketsService.onCryingEventOccurence = { [unowned self] in
            self.cryingEventPublisher.onNext(())
            let eventMessage = EventMessage.initWithMessageReceived()
            let data = try! JSONEncoder().encode(eventMessage)
            let jsonString = String(data: data, encoding: .utf8)!
            self.messageServer.send(message: jsonString)
        }
    }
}
