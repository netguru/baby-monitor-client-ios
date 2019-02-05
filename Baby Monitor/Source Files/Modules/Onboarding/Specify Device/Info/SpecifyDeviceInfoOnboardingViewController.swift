//
//  SpecifyDeviceInfoOnboardingViewController.swift
//  Baby Monitor
//

import Foundation
import RxSwift

final class SpecifyDeviceInfoOnboardingViewController: TypedViewController<SpecifyDeviceInfoOnboardingView> {

    private let viewModel: SpecifyDeviceInfoOnboardingViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: SpecifyDeviceInfoOnboardingViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: SpecifyDeviceInfoOnboardingView())
    }
}
