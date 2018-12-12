//
//  ConnectionCheckerMock.swift
//  Baby MonitorTests
//

import RxSwift
@testable import BabyMonitor

final class ConnectionCheckerMock: ConnectionChecker {
    
    var connectionStatus: Observable<ConnectionStatus> {
        return connectionStatusPublisher
    }
    private(set) var isStarted: Bool = false
    private(set) var connectionStatusPublisher = PublishSubject<ConnectionStatus>()
    
    func start() {
        isStarted = true
    }
    
    func stop() {
        isStarted = false
    }
}
