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
        netServiceClient.findService()
    }
    
    func stop() {
        netServiceClient.stopFinding()
    }
    
    private func createStatus() -> Observable<ConnectionStatus> {
        let status = netServiceClient.serviceObservable
            .filter { ip, port in
                URL.with(ip: ip, port: port, prefix: Constants.protocolPrefix) == self.urlConfiguration.url
            }
            .buffer(timeSpan: delay, count: 1, scheduler: MainScheduler.asyncInstance)
            .map { !($0.isEmpty) }
            .map { isServiceAvailable in
                isServiceAvailable ? ConnectionStatus.connected : ConnectionStatus.disconnected
            }
        return status
    }
}
