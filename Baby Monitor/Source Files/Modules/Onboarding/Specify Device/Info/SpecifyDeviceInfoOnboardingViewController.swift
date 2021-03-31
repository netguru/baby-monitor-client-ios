//
//  SpecifyDeviceInfoOnboardingViewController.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import Baby_MonitorCoreKit

final class SpecifyDeviceInfoOnboardingViewController: TypedViewController<SpecifyDeviceInfoOnboardingView> {

    private let viewModel: SpecifyDeviceInfoOnboardingViewModel

    init(viewModel: SpecifyDeviceInfoOnboardingViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: SpecifyDeviceInfoOnboardingView(),
                   analytics: viewModel.analytics,
                   analyticsScreenType: .specifyDeviceInfoOnboarding)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.attachInput(
            specifyDeviceTap: customView.rx.specifyDeviceTap.asObservable())
        customView.descriptionLabel.attributedText = viewModel.descriptionText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
