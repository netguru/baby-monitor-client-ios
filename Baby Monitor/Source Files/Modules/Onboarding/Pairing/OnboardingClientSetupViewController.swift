//
//  OnboardingClientSetupViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift

final class OnboardingClientSetupViewController: TypedViewController<OnboardingSpinnerView> {
    
    private let viewModel: ClientSetupOnboardingViewModel
    private let bag = DisposeBag()

    init(viewModel: ClientSetupOnboardingViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: OnboardingSpinnerView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startDiscovering(withTimeout: Constants.pairingDeviceSearchTimeLimit)
    }
    
    private func setup() {
        customView.update(title: viewModel.title)
        customView.update(mainDescription: viewModel.description)
        customView.update(image: viewModel.image)
        viewModel.attachInput(cancelButtonTap: customView.rx.cancelTap.asObservable())
        customView.rx.cancelTap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        })
        .disposed(by: bag)
    }
}
