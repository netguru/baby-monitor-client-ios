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
    func selectSetupAddress(_ address: String?) {
        didSelectSetupAddress?(address)
    }
    
    func selectStartDiscovering() {
        didSelectStartDiscovering?()
    }
}
