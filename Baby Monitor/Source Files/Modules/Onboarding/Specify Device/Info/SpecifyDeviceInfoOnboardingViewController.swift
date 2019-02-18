//
//  SpecifyDeviceInfoOnboardingViewController.swift
//  Baby Monitor
//

import Foundation
import RxSwift

final class SpecifyDeviceInfoOnboardingViewController: TypedViewController<SpecifyDeviceInfoOnboardingView> {

    private let viewModel: SpecifyDeviceInfoOnboardingViewModel

    init(viewModel: SpecifyDeviceInfoOnboardingViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: SpecifyDeviceInfoOnboardingView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = customView.cancelItemButton
        viewModel.attachInput(
            specifyDeviceTap: customView.rx.specifyDeviceTap.asObservable(),
            cancelTap: customView.rx.cancelTap.asObservable())
        customView.descriptionLabel.attributedText = viewModel.descriptionText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
