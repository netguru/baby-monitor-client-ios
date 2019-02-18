//
//  OnboardingContinuableViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import AVFoundation

final class OnboardingContinuableViewController: TypedViewController<ContinuableBaseOnboardingView> {
    
    private let viewModel: OnboardingContinuableViewModel
    
    init(viewModel: OnboardingContinuableViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: ContinuableBaseOnboardingView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setup() {
        navigationItem.leftBarButtonItem = customView.cancelButtonItem
        customView.update(title: viewModel.title)
        customView.update(mainDescription: viewModel.description)
        customView.update(image: viewModel.image)
        customView.update(buttonTitle: viewModel.buttonTitle)
        customView.update(secondaryDescription: viewModel.secondDescription)
        viewModel.attachInput(
            buttonTap: customView.rx.buttonTap.asObservable(),
            cancelButtonTap: customView.rx.cancelButtonTap.asObservable())
    }
}
