//
//  SpecifyDeviceOnboardingViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift

final class SpecifyDeviceOnboardingViewController: TypedViewController<SpecifyDeviceOnboardingView> {
    
    private let viewModel: SpecifyDeviceOnboardingViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: SpecifyDeviceOnboardingViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: SpecifyDeviceOnboardingView())
        rxSetup()
    }
    
    private func rxSetup() {
        customView.parentTapEvent.subscribe(onNext: { [weak self] _ in
            self?.viewModel.selectParent()
        }).disposed(by: disposeBag)
        customView.babyTapEvent.subscribe(onNext: { [weak self] _ in
            self?.viewModel.selectBaby()
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = customView.cancelItemButton
        viewModel.attachInput(cancelTap: customView.rx.cancelTap.asObservable())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.analyticsManager.logScreen(.specifyDevice, className: className)
    }
}
