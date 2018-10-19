//
//  ClientSetupViewModel.swift
//  Baby Monitor
//

import Foundation

enum DeviceSearchError: Error {
    case timeout
}

enum DeviceSearchResult {
    case success
    case failure(DeviceSearchError)
}

extension DeviceSearchResult: Equatable {
    public static func == (lhs: DeviceSearchResult, rhs: DeviceSearchResult) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success):
            return true
        case (.failure(let lerror), .failure(let rerror)):
            switch (lerror, rerror) {
            case (.timeout, .timeout):
                return true
            }
        default:
            return false
        }
    }
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
        didSelectSetupAddress?(address)
    }
    
    func selectStartDiscovering(withTimeout timeout: TimeInterval = 5.0) {
        searchCancelTimer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false, block: { [weak self] _ in
            self?.didEndDeviceSearch?(.failure(.timeout))
            self?.searchCancelTimer = nil
        })
        netServiceClient.didFindServiceWith = { [weak self] ip, port in
            guard let `self` = self,
                let serverUrl = URL.rtspUrl(fromIp: ip, andPort: port) else {
                return
            }
            self.searchCancelTimer?.invalidate()
            self.rtspConfiguration.url = serverUrl
            self.didEndDeviceSearch?(.success)
        }
        netServiceClient.findService()
        didStartDeviceSearch?()
    }
}
