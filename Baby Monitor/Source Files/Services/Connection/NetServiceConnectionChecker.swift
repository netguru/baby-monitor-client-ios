//
//  NetServiceConnectionChecker.swift
//  Baby Monitor
//

import RxSwift

final class NetServiceConnectionChecker: ConnectionChecker {
    
    lazy var connectionStatus: Observable<ConnectionStatus> = createStatus()
    
    private let netServiceClient: NetServiceClientProtocol
    private let urlConfiguration: URLConfiguration
    private let delay: TimeInterval
    
    init(netServiceClient: NetServiceClientProtocol, urlConfiguration: URLConfiguration, delay: TimeInterval = 2.0) {
        self.netServiceClient = netServiceClient
        self.urlConfiguration = urlConfiguration
        self.delay = delay
    }
    
    func start() {
        netServiceClient.isEnabled.accept(true)
    }
    
    func stop() {
        netServiceClient.isEnabled.accept(false)
    }
    
    private func createStatus() -> Observable<ConnectionStatus> {
        return netServiceClient.services.map { !$0.isEmpty ? .connected : .disconnected }.distinctUntilChanged()
    }
}
