//
//  InitialSetupViewModel.swift
//  Baby Monitor
//


import Foundation

final class InitialSetupViewModel {
    
    //MARK: - Coordinator callback
    var didSelectStartClient: (() -> Void)?
    var didSelectStartServer: (() -> Void)?
    
    //MARK: - Internal functions
    func selectStartClient() {
        didSelectStartClient?()
    }
    
    func selectStartServer() {
        didSelectStartServer?()
    }
}
