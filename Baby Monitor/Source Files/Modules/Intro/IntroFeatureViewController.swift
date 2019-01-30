//
//  IntroFeatureViewController.swift
//  Baby Monitor
//

import UIKit

class IntroFeatureViewController: TypedViewController<IntroFeatureView> {

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
        navigationController?.navigationBar.isHidden = true
        customView.setupBackgroundImage(UIImage())
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
