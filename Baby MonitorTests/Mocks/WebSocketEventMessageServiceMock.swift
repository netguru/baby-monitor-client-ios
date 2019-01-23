//
//  WebSocketEventMessageServiceMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import RxSwift

final class WebSocketEventMessageServiceMock: WebSocketEventMessageServiceProtocol {

    lazy var cryingEventObservable: Observable<Void> = cryingEventPublisher.asObservable()
    private let cryingEventPublisher = PublishSubject<Void>()
    private(set) var isStarted = false
    private(set) var messages = [String]()

    func start() {
        isStarted = true
    }

    func sendMessage(_ message: String) {
        messages.append(message)
    }
}
