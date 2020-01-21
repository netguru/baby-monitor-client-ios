//
//  IntroFeatureViewController.swift
//  Baby Monitor
//

import UIKit

final class IntroFeatureViewController: TypedViewController<IntroFeatureView> {

    private let viewModel: IntroViewModel
    
    init(viewModel: IntroViewModel, role: IntroFeature) {
        self.viewModel = viewModel
        super.init(viewMaker: IntroFeatureView(role: role))
    }
    
    override func viewDidLoad() {
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customView.setupBackgroundImage(UIImage())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.analyticsManager.logScreen(.onboarding, className: className)
    }
    
    private func setup() {
        customView.didSelectRightAction = { [weak self] in
            self?.viewModel.selectRightAction()
        }
        customView.didSelectLeftAction = { [weak self] in
            self?.viewModel.selectLeftAction()
        }
    }
}
