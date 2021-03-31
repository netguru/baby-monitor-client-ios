//
//  OnboardingAccessViewController.swift
//  Baby Monitor
//

import Foundation
import Baby_MonitorCoreKit

final class OnboardingAccessViewController: TypedViewController<AccessBaseOnboardingView> {
    
    private let viewModel: OnboardingAccessViewModel
    
    init(viewModel: OnboardingAccessViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: AccessBaseOnboardingView(),
                   analytics: viewModel.analytics,
                   analyticsScreenType: viewModel.analyticsScreenType)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.checkAccess()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setup() {
        customView.update(title: viewModel.title)
        customView.update(mainDescription: viewModel.description)
        customView.update(image: viewModel.image)
        customView.update(accessDescription: viewModel.accessDescription)
    }
}
