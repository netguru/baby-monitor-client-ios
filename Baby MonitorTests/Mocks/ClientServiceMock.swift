//
//  ClientServiceMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import RxSwift

final class ClientServiceMock: ClientServiceProtocol {
    var cryingEventObservable: Observable<Void> = Observable.empty()
    func start() {}
    func sendMessageToServer(message: String) {}
}
