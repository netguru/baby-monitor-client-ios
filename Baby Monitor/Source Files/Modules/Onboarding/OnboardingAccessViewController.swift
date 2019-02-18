//
//  OnboardingAccessViewController.swift
//  Baby Monitor
//

import Foundation

final class OnboardingAccessViewController: TypedViewController<AccessBaseOnboardingView> {
    
    private let viewModel: OnboardingAccessViewModel
    
    init(viewModel: OnboardingAccessViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: AccessBaseOnboardingView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.checkAccess()
    }
    
    private func setup() {
        customView.update(title: viewModel.title)
        customView.update(mainDescription: viewModel.description)
        customView.update(image: viewModel.image)
        customView.update(accessDescription: viewModel.accessDescription)
    }
}
