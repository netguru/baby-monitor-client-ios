//
//  SettingsViewController.swift
//  Baby Monitor
//

import UIKit

final class SettingsViewController: BabyMonitorGeneralViewController {
    
    private let viewModel: SettingsViewModel
    
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
        customView.babyNavigationItemView.onSelectArrow = { [weak self] in
            self?.viewModel.selectShowBabies()
        }
    }
}
