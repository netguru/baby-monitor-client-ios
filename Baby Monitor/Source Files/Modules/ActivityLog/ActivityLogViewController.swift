//
//  ActivityLogViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift

final class ActivityLogViewController: BabyMonitorGeneralViewController {
    
    private let viewModel: ActivityLogViewModel
    private let bag = DisposeBag()
    
    init(viewModel: ActivityLogViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel, type: .activityLog)
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
