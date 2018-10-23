//
//  ClientSetupViewModel.swift
//  Baby Monitor
//

import Foundation

enum DeviceSearchError: Error {
    case timeout
}

enum DeviceSearchResult: Equatable {
    case success
    case failure(DeviceSearchError)
}

final class ClientSetupViewModel {
    
    // MARK: - Coordinator callback
    var didSelectSetupAddress: ((_ address: String?) -> Void)?
    var didEndDeviceSearch: ((DeviceSearchResult) -> Void)?
    var didStartDeviceSearch: (() -> Void)?
    
    // MARK: - Private properties
    
    private let netServiceClient: NetServiceClientProtocol
    private let rtspConfiguration: RTSPConfiguration
    private var searchCancelTimer: Timer?
    
    // MARK: - Internal functions
    
    init(netServiceClient: NetServiceClientProtocol, rtspConfiguration: RTSPConfiguration) {
        self.netServiceClient = netServiceClient
        self.rtspConfiguration = rtspConfiguration
    }

    /// Sets up the address of an available baby (server) to connect to.
    ///
    /// - Parameter address: The address of a server device.
    func selectSetupAddress(_ address: String?) {
        guard let address = address else { return }
        let url = URL(string: address)
        rtspConfiguration.url = url
        didEndDeviceSearch?(.success)
    }
    
    func selectStartDiscovering(withTimeout timeout: TimeInterval = 5.0) {
        searchCancelTimer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false, block: { [weak self] _ in
            self?.netServiceClient.stopFinding()
            self?.searchCancelTimer = nil
            self?.didEndDeviceSearch?(.failure(.timeout))
        })
        netServiceClient.didFindServiceWith = { [weak self] ip, port in
            guard let self = self,
                let serverUrl = URL.rtsp(ip: ip, port: port) else {
                return
            }
            self.searchCancelTimer?.invalidate()
            self.rtspConfiguration.url = serverUrl
            self.netServiceClient.stopFinding()
            self.didEndDeviceSearch?(.success)
        }
        netServiceClient.findService()
        didStartDeviceSearch?()
    }
}
