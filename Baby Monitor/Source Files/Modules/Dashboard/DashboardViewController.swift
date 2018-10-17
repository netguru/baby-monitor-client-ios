//
//  DashboardViewController.swift
//  Baby Monitor
//

import UIKit

final class DashboardViewController: TypedViewController<DashboardView> {
    
    private let viewModel: DashboardViewModel
    
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: DashboardView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Selectors
    @objc private func didTouchEditProfileButton() {
        //TODO: add implementation
    }
    
    // MARK: - Private functions
    private func setup() {
        navigationItem.rightBarButtonItem = customView.editProfileBarButtonItem
        navigationItem.titleView = customView.babyNavigationItemView
        customView.babyNavigationItemView.onSelectArrow = { [weak self] in
            self?.viewModel.selectSwitchBaby()
        }
        customView.liveCameraButton.onSelect = { [weak self] in
            self?.viewModel.selectLiveCameraPreview()
        }
    }
}
