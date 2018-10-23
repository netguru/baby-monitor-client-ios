//
//  GeneralOnboardingViewController.swift
//  Baby Monitor
//

import UIKit

protocol OnboardingViewModelProtocol: AnyObject {
    var selectFirstAction: (() -> Void)? { get }
    var selectSecondAction: (() -> Void)? { get }
}

protocol ServiceDiscoverable {
    func startDiscovering(withTimeout timeout: TimeInterval)
}

final class GeneralOnboardingViewController: TypedViewController<OnboardingView> {
    
    private let viewModel: OnboardingViewModelProtocol
    
    init(viewModel: OnboardingViewModelProtocol, role: OnboardingView.Role) {
        self.viewModel = viewModel
        super.init(viewMaker: OnboardingView(role: role))
        setup()
    }
    
    private func setup() {
        if let discoverableViewModel = viewModel as? ServiceDiscoverable {
            discoverableViewModel.startDiscovering(withTimeout: 5.0)
        }
        customView.didSelectFirstAction = { [weak self] in
            self?.viewModel.selectFirstAction?()
        }
        customView.didSelectSecondAction = { [weak self] in
            self?.viewModel.selectSecondAction?()
        }
    }
}
