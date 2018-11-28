//
//  SpecifyDeviceOnboardingViewModel.swift
//  Baby Monitor
//

import Foundation

final class SpecifyDeviceOnboardingViewModel {
    
    var didSelectParent: (() -> Void)?
    var didSelectBaby: (() -> Void)?
    
    func selectParent() {
        didSelectParent?()
    }
    
    func selectBaby() {
        didSelectBaby?()
    }
}
