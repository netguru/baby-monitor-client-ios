//
//  LullabiesViewController.swift
//  Baby Monitor
//

import UIKit

final class LullabiesViewController: BabyMonitorGeneralViewController {
    
    private let viewModel: LullabiesViewModel
    
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
        customView.babyNavigationItemView.onSelectArrow = { [weak self] in
            self?.viewModel.selectShowBabies()
        }
    }
}
