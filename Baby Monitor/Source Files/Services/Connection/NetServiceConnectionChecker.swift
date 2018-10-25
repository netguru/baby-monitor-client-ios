//
//  NetServiceConnectionChecker.swift
//  Baby Monitor
//

import RxSwift

final class NetServiceConnectionChecker: ConnectionChecker {
    
    var didUpdateStatus: ((ConnectionStatus) -> Void)?
    lazy var connectionStatus: Observable<ConnectionStatus> = createStatus()
    
    private let netServiceClient: NetServiceClientProtocol
    private let rtspConfiguration: RTSPConfiguration
    private let delay: TimeInterval
    
    init(netServiceClient: NetServiceClientProtocol, rtspConfiguration: RTSPConfiguration, delay: TimeInterval = 2.0) {
        self.netServiceClient = netServiceClient
        self.rtspConfiguration = rtspConfiguration
        self.delay = delay
    }
    
    func start() {
        netServiceClient.findService()
    }
    
    func stop() {
        netServiceClient.stopFinding()
    }
    
    private func createStatus() -> Observable<ConnectionStatus> {
        let status = netServiceClient.service
            .filter { ip, port in
                URL.rtsp(ip: ip, port: port) == self.rtspConfiguration.url
            }
            .buffer(timeSpan: delay, count: 1, scheduler: MainScheduler.asyncInstance)
            .map { !($0.isEmpty) }
            .map { isServiceAvailable in
                isServiceAvailable ? ConnectionStatus.connected : ConnectionStatus.disconnected
            }
        return status
    }
}
