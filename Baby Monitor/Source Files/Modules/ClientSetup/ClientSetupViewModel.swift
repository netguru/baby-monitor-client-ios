//
//  ClientSetupViewModel.swift
//  Baby Monitor
//


import Foundation

final class ClientSetupViewModel {
    
    //MARK: - Coordinator callback
    var didSelectSetupAddress: ((_ address: String?) -> Void)?
    var didSelectStartDiscovering: (() -> Void)?
    
    //MARK: - Internal functions

    /// Sets up the address of an available baby (server) to connect to.
    ///
    /// - Parameter address: The address of a server device.
    func selectSetupAddress(_ address: String?) {
        didSelectSetupAddress?(address)
    }
    
    func selectStartDiscovering() {
        didSelectStartDiscovering?()
    }
}
