//
//  ActivityLogViewController.swift
//  Baby Monitor
//

import UIKit

final class ActivityLogViewController: BabyMonitorGeneralViewController {
    
    private let viewModel: ActivityLogViewModel
    
    init(viewModel: ActivityLogViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel, type: .activityLog)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.babyService.addObserver(self)
    }
    
    // MARK: - Private functions
    private func setup() {
        navigationItem.titleView = customView.babyNavigationItemView
        customView.babyNavigationItemView.onSelectArrow = { [weak self] in
            self?.viewModel.selectShowBabies()
        }
        updateNavigationView()
    }
}
