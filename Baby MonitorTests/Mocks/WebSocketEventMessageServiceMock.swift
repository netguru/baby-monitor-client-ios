//
//  WebSocketEventMessageServiceMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import RxSwift

final class WebSocketEventMessageServiceMock: WebSocketEventMessageServiceProtocol {

    lazy var remoteResetObservable: Observable<Void> = remoteResetPublisher.asObservable()
    lazy var remotePairingCodeResponseObservable: Observable<Bool> = remotePairingCodeResponsePublisher.asObservable()
    private let remoteResetPublisher = PublishSubject<Void>()
    private let remotePairingCodeResponsePublisher = PublishSubject<Bool>()
    private(set) var isOpen = false
    private(set) var messages = [String]()

    func start() {
        isOpen = true
    }

    func close() {
        isOpen = false
    }

    func sendMessage(_ message: String) {
        messages.append(message)
    }
}
