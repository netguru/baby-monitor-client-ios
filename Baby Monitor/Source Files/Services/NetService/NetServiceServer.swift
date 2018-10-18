//
//  NetServiceServer.swift
//  Baby Monitor
//

import Foundation

protocol NetServiceServerProtocol {
    func publish()
    func stop()
}

final class NetServiceServer: NSObject, NetServiceServerProtocol {
    
    private let netService: NetService
    
    init(netService: NetService = NetService(domain: Constants.domain,
                                             type: Constants.netServiceType,
                                             name: Constants.netServiceName,
                                             port: 554)) {
        self.netService = netService
    }
    
    func publish() {
        netService.publish()
    }
    
    func stop() {
        netService.stop()
    }
}
