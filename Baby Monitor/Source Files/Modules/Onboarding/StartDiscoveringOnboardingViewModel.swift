//
//  StartDiscoveringOnboardingViewModel.swift
//  Baby Monitor
//

import Foundation

final class StartDiscoveringOnboardingViewModel: OnboardingViewModelProtocol {
    lazy var selectFirstAction: (() -> Void)? = { [weak self] in
        self?.didSelectStartDiscovering?()
    }
    var selectSecondAction: (() -> Void)?
    var didSelectStartDiscovering: (() -> Void)?
}
