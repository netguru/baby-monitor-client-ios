//
//  InitialOnboardingViewModel.swift
//  Baby Monitor
//

import Foundation

final class InitialOnboardingViewModel: OnboardingViewModelProtocol {
    
    lazy var selectFirstAction: (() -> Void)? = { [weak self] in
        self?.didSelectBabyMonitorServer?()
    }
    lazy var selectSecondAction: (() -> Void)? = { [weak self] in
        self?.didSelectBabyMonitorClient?()
    }
    
    // MARK: - Coordinator callback
    var didSelectBabyMonitorServer: (() -> Void)?
    var didSelectBabyMonitorClient: (() -> Void)?
}
