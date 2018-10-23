//
//  NetServiceConnectionChecker.swift
//  Baby Monitor
//

final class NetServiceConnectionChecker: ConnectionChecker {
    
    var didUpdateStatus: ((ConnectionStatus) -> Void)?
    
    private let netServiceClient: NetServiceClientProtocol
    private let rtspConfiguration: RTSPConfiguration
    private let delay: TimeInterval
    
    private var timer: Timer?
    
    init(netServiceClient: NetServiceClientProtocol, rtspConfiguration: RTSPConfiguration, delay: TimeInterval = 2.0) {
        self.netServiceClient = netServiceClient
        self.rtspConfiguration = rtspConfiguration
        self.delay = delay
    }
    
    func start() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: { [weak self] timer in
            self?.stop()
            self?.start()
            self?.didUpdateStatus?(.disconnected)
        })
        netServiceClient.didFindServiceWith = { [weak self] ip, port in
            guard let url = URL.rtsp(ip: ip, port: port), url == self?.rtspConfiguration.url else {
                return
            }
            self?.stop()
            self?.start()
            self?.didUpdateStatus?(.connected)
        }
        netServiceClient.findService()
    }
    
    func stop() {
        timer?.invalidate()
        netServiceClient.stopFinding()
    }
}
