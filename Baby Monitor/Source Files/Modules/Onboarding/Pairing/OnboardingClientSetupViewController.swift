//
//  OnboardingClientSetupViewController.swift
//  Baby Monitor
//

import UIKit

final class OnboardingClientSetupViewController: TypedViewController<OnboardingSpinnerView> {
    private let viewModel: ClientSetupOnboardingViewModel
    
    init(role: ImageOnboardingView.Role, viewModel: ClientSetupOnboardingViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: OnboardingSpinnerView(role: role))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startDiscovering(withTimeout: 5.0)
    }
    
}
