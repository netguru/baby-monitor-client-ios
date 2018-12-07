//
//  OnboardingContinuableViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift

final class OnboardingContinuableViewController: TypedViewController<ImageOnboardingView> {
    
    private let viewModel: OnboardingContinuableViewModel
    private let disposeBag = DisposeBag()
    
    init(role: ImageOnboardingView.Role, viewModel: OnboardingContinuableViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: ImageOnboardingView(role: role))
        
        rxSetup()
    }
    
    private func rxSetup() {
        customView.nextButtonObservable.subscribe(onNext: { [weak self] _ in
            self?.viewModel.selectNext()
        }).disposed(by: disposeBag)
    }
}