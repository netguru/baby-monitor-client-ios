//
//  OnboardingCompareCodeViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift

final class OnboardingCompareCodeViewController: TypedViewController<OnboardingCompareCodeView> {

    private let viewModel: OnboardingCompareCodeViewModel
    private let bag = DisposeBag()
    
    init(viewModel: OnboardingCompareCodeViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: OnboardingCompareCodeView())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        customView.update(title: viewModel.title)
        customView.update(mainDescription: viewModel.description)
        customView.update(codeText: viewModel.codeText)
        navigationItem.leftBarButtonItem = customView.backButtonItem
        setupBindings()
   }

    private func setupBindings() {
        customView.rx.backButtonTap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: bag)
    }
}
