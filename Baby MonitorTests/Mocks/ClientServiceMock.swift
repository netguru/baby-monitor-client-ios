//
//  ClientServiceMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import Foundation
import RxSwift

final class ClientServiceMock: ClientServiceProtocol {
    let cryingEventPublisher = PublishSubject<Void>()
    lazy var cryingEventObservable = cryingEventPublisher.asObservable()
    
    func start() { }
    func sendMessageToServer(message: String) { }
}
