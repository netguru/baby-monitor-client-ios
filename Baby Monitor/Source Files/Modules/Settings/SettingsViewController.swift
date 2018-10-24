//
//  SettingsViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift

final class SettingsViewController: BabyMonitorGeneralViewController {
    
    private let viewModel: SettingsViewModel
    private let bag = DisposeBag()
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel, type: .settings)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.addObserver(self)
    }
    
    deinit {
        viewModel.removeObserver(self)
    }
    
    // MARK: - Private functions
    private func setup() {
        navigationItem.titleView = customView.babyNavigationItemView
        customView.rx.switchBabiesTap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.selectShowBabies()
            })
            .disposed(by: bag)
    }
}
