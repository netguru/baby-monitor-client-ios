//
//  DashboardViewModel.swift
//  Baby Monitor
//

import Foundation

final class DashboardViewModel {
    
    //MARK: - Coordinator callback
    var didSelectShowBabies: (() -> Void)?
    var didSelectLiveCameraPreview: (() -> Void)?
    
    //MARK: - Internal functions
    func selectSwitchBaby() {
        didSelectShowBabies?()
    }
    
    func selectLiveCameraPreview() {
        didSelectLiveCameraPreview?()
    }
}
