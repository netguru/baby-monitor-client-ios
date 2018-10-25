//
//  NetClientMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import RxSwift
import RxCocoa

final class NetServiceClientMock: NetServiceClientProtocol {
    var service: Observable<(ip: String, port: String)> {
        return servicePublisher.asObservable()
    }
    private let servicePublisher = PublishRelay<(ip: String, port: String)>()
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
        timer = Timer.scheduledTimer(withTimeInterval: findServiceDelay, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            self.servicePublisher.accept((self.ip, self.port))
        })
    }
    
    func stopFinding() {
        timer?.invalidate()
    }
    
    func forceFind(delay: Double = 0.0) {
        timer?.invalidate()
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.servicePublisher.accept((self.ip, self.port))
        }
    }
}
