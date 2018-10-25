//
//  LullabiesViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift

final class LullabiesViewController: BabyMonitorGeneralViewController {
    
    private let viewModel: LullabiesViewModel
    private let bag = DisposeBag()
    
    init(viewModel: LullabiesViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel, type: .lullaby)
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
