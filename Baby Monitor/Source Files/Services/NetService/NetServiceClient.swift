//
//  NetServiceClient.swift
//  Baby Monitor
//

import Foundation

protocol NetServiceClientProtocol: AnyObject {
    typealias IP = String
    typealias Port = String
    
    var didFindServiceWith: ((IP, Port) -> Void)? { get set }
    
    func findService()
}

final class NetServiceClient: NSObject, NetServiceClientProtocol {
    
    var didFindServiceWith: ((NetServiceClient.IP, NetServiceClient.Port) -> Void)?
    
    private var service: NetService?
    private let netServiceBrowser = NetServiceBrowser()
    
    override init() {
        super.init()
        netServiceBrowser.delegate = self
    }
    
    func findService() {
        netServiceBrowser.searchForServices(ofType: "_http._tcp.", inDomain: "local.")
    }
}

// MARK: - NetServiceBrowserDelegate
extension NetServiceClient: NetServiceBrowserDelegate {
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        service.delegate = self
        self.service = service
        service.resolve(withTimeout: 5)
    }
}

// MARK: - NetServiceDelegate
extension NetServiceClient: NetServiceDelegate {
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        guard let addressData = sender.addresses?.first else {
            return
        }
        let theAddress = NSData(data: addressData)
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        let pointer = theAddress.bytes.assumingMemoryBound(to: sockaddr.self)
        if getnameinfo(pointer, socklen_t(theAddress.length), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
            let numAddress = String(cString: hostname)
            didFindServiceWith?(numAddress, "\(sender.port)")
        }
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String: NSNumber]) {
        //TODO: implement error handling
    }
}
