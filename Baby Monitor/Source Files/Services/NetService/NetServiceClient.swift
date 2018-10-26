//
//  NetServiceClient.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import RxCocoa

protocol NetServiceClientProtocol: AnyObject {
    var serviceObservable: Observable<(ip: String, port: String)> { get }
    func findService()
    func stopFinding()
}

final class NetServiceClient: NSObject, NetServiceClientProtocol {
    
    lazy var serviceObservable = servicePublisher.asObservable()
    
    private var netService: NetService?
    
    private let servicePublisher = PublishRelay<(ip: String, port: String)>()
    private let netServiceBrowser = NetServiceBrowser()
    
    override init() {
        super.init()
        netServiceBrowser.delegate = self
    }
    
    func findService() {
        // Apparently net service browser doesn't allow to call stop/searchForDevices in quick succession, hence the async
        DispatchQueue.main.async { [weak self] in
            self?.netServiceBrowser.searchForServices(ofType: Constants.netServiceType, inDomain: Constants.domain)
        }
    }
    
    func stopFinding() {
        netServiceBrowser.stop()
    }
}

// MARK: - NetServiceBrowserDelegate
extension NetServiceClient: NetServiceBrowserDelegate {
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        service.delegate = self
        self.netService = service
        service.resolve(withTimeout: 5)
    }
}

// MARK: - NetServiceDelegate
extension NetServiceClient: NetServiceDelegate {
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        guard let addressData = sender.addresses?.first,
            let ip = getIP(from: addressData) else {
                return
        }
        servicePublisher.accept((ip, "\(sender.port)"))
        stopFinding()
        findService()
    }
    
    private func getIP(from data: Data) -> String? {
        let theAddress = NSData(data: data)
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        let pointer = theAddress.bytes.assumingMemoryBound(to: sockaddr.self)
        if getnameinfo(pointer, socklen_t(theAddress.length), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
            return String(cString: hostname)
        } else {
            return nil
        }
    }
    
}
