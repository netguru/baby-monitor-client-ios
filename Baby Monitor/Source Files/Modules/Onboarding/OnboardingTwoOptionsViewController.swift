//
//  OnboardingTwoOptionsViewController.swift
//  Baby Monitor
//

import Foundation

final class OnboardingTwoOptionsViewController: TypedViewController<TwoOptionsBaseOnboardingView> {
    
    private let viewModel: OnboardingTwoOptionsViewModel
    
    init(viewModel: OnboardingTwoOptionsViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: TwoOptionsBaseOnboardingView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        customView.update(title: viewModel.title)
        customView.update(mainDescription: viewModel.mainDescription)
        customView.update(secondaryDescription: viewModel.secondaryDescription)
        customView.update(image: viewModel.image)
        customView.update(upButtonTitle: viewModel.upButtonTitle)
        customView.update(bottomButtonTitle: viewModel.bottomButtonTitle)
        viewModel.attachInput(
            upButtonTap: customView.rx.upButtonTap.asObservable(),
            bottomButtonTap: customView.rx.bottomButtonTap.asObservable())
    }
}
