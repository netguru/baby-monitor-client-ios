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
    
    private let netService = NetService(domain: "local.", type: "_http._tcp.", name: "Baby Monitor Service", port: 554)
    
    func publish() {
        netService.publish()
    }
    
    func stop() {
        netService.stop()
    }
}
