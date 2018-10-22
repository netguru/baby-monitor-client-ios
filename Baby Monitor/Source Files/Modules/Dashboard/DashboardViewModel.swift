//
//  DashboardViewModel.swift
//  Baby Monitor
//

import Foundation

final class DashboardViewModel {
    
    // MARK: - Coordinator callback
    var didSelectShowBabies: (() -> Void)?
    var didSelectLiveCameraPreview: (() -> Void)?
    var didUpdateStatus: ((ConnectionStatus) -> Void)?
    
    // MARK: - Private properties
    private let connectionChecker: ConnectionChecker
    
    init(connectionChecker: ConnectionChecker) {
        self.connectionChecker = connectionChecker
        setup()
    }
    
    deinit {
        connectionChecker.stop()
    }
    
    // MARK: - Internal functions
    func selectSwitchBaby() {
        didSelectShowBabies?()
    }
    
    func selectLiveCameraPreview() {
        didSelectLiveCameraPreview?()
    }
    
    // MARK: - Private functions
    private func setup() {
        connectionChecker.didUpdateStatus = { [weak self] status in
            self?.didUpdateStatus?(status)
        }
        connectionChecker.start()
    }
}
