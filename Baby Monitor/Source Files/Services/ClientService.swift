//
//  ClientService.swift
//  Baby Monitor
//

import Foundation
import RxSwift

protocol ClientServiceProtocol: AnyObject {
    var cryingEventObservable: Observable<Void> { get }
    /// Starts client service work
    func start()
    /// Sends message to server app
    func sendMessageToServer(message: String)
}

final class ClientService: ClientServiceProtocol {
    
    lazy var cryingEventObservable = cryingEventPublisher.asObservable()
    
    private let cryingEventPublisher = PublishSubject<Void>()
    private let websocketsService: WebSocketsServiceProtocol
    private let localNotificationService: NotificationServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(websocketsService: WebSocketsServiceProtocol, localNotificationService: NotificationServiceProtocol, messageServer: MessageServerProtocol) {
        self.websocketsService = websocketsService
        self.localNotificationService = localNotificationService
        setup()
    }
    
    func start() {
        websocketsService.play()
    }
    
    func sendMessageToServer(message: String) {
        websocketsService.sendMessageToServer(message: message)
    }
    
    private func setup() {
        websocketsService.onCryingEventOccurence = { [unowned self] in
            self.cryingEventPublisher.onNext(())
            let eventMessage = EventMessage.initWithMessageReceived()
            let data = try! JSONEncoder().encode(eventMessage)
            let jsonString = String(data: data, encoding: .utf8)!
            self.sendMessageToServer(message: jsonString)
        }
    }
}
