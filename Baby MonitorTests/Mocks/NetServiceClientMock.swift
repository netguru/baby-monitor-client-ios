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
    private var timer: Timer?
    
    init(findServiceDelay: Double = 0.0, ip: String = "ip", port: String = "port") {
        self.findServiceDelay = findServiceDelay
        self.ip = ip
        self.port = port
    }
    
    private(set) var didCallFindService: Bool = false
    
    func findService() {
        didCallFindService = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: findServiceDelay, repeats: false, block: { [unowned self] _ in
            self.didFindServiceWith?(self.ip, self.port)
        })
    }
    
    func stopFinding() {
        timer?.invalidate()
        didFindServiceWith = nil
    }
    
    func forceFind(delay: Double = 0.0) {
        timer?.invalidate()
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.didFindServiceWith?(self.ip, self.port)
        }
    }
}
