//
//  WebSocketEventMessageServiceMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import RxSwift

final class WebSocketEventMessageServiceMock: WebSocketEventMessageServiceProtocol {

    lazy var remoteResetObservable: Observable<Void> = remoteResetPublisher.asObservable()
    private let remoteResetPublisher = PublishSubject<Void>()
    private(set) var isStarted = false
    private(set) var messages = [String]()

    func start() {
        isStarted = true
    }

    func sendMessage(_ message: String) {
        messages.append(message)
    }
}
