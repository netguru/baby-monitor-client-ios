//
//  NetServiceClient.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import RxCocoa

protocol NetServiceClientProtocol: AnyObject {
    var service: Observable<(ip: String, port: String)> { get }
    //    var didFindServiceWith: ((_ ip: String, _ port: String) -> Void)? { get set }
    
    func findService()
    
    func stopFinding()
}

final class NetServiceClient: NSObject, NetServiceClientProtocol {
    
    var service: Observable<(ip: String, port: String)> {
        return servicePublisher.asObservable()
    }
    
    private let servicePublisher = PublishRelay<(ip: String, port: String)>()
    
    //    var didFindServiceWith: ((ip: String, port: String) -> Void)?
    
    private var netService: NetService?
    private let netServiceBrowser = NetServiceBrowser()
    
    private static let androidPort = 5006
    private static let iosPort = 554
    
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
            let ip = getIP(from: addressData), [NetServiceClient.androidPort, NetServiceClient.iosPort].contains(sender.port) else {
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
