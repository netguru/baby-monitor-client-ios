//
//  NetClientMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

final class NetServiceClientMock: NetServiceClientProtocol {
    var didFindServiceWith: ((_ ip: String, _ port: String) -> Void)?
    private let findServiceDelay: Double
    private let ip: String
    private let port: String
    
    init(findServiceDelay: Double = 0.0, ip: String = "ip", port: String = "port") {
        self.findServiceDelay = findServiceDelay
        self.ip = ip
        self.port = port
    }
    
    private(set) var didCallFindService: Bool = false
    
    func findService() {
        didCallFindService = true
        DispatchQueue.main.asyncAfter(deadline: .now() + findServiceDelay) { [unowned self] in
            self.didFindServiceWith?(self.ip, self.port)
        }
    }
}
