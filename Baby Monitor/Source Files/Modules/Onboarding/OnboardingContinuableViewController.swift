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
        super.init(viewMaker: ContinuableBaseOnboardingView(),
                   analyticsManager: viewModel.analyticsManager,
                   analyticsScreenType: viewModel.analyticsScreenType)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if case .parent(.allDone) = viewModel.role {
            navigationController?.setNavigationBarHidden(true, animated: false)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }

    private func setup() {
        if case .parent(.searchingError) = viewModel.role,
            case .parent(.connectionError) = viewModel.role {
            customView.changeButtonBackgroundColor(.clear)
        }
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
