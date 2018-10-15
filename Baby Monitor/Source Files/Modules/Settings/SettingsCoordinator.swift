//
//  SettingsCoordinator.swift
//  Baby Monitor
//


import UIKit

final class SettingsCoordinator: Coordinator, BabiesViewShowable {
    
    var appDependencies: AppDependencies
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var switchBabyViewController: BabyMonitorGeneralViewController?
    var onEnding: (() -> Void)?
    
    private var settingsViewController: BabyMonitorGeneralViewController?
    
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.appDependencies = appDependencies
        self.navigationController = navigationController
    }
    
    func start() {
        showSettings()
    }
    
    //MARK: - private functions
    private func showSettings() {
        let viewModel = SettingsViewModel()
        viewModel.didSelectShowBabiesView = { [weak self] in
            guard let settingsViewController = self?.settingsViewController else {
                return
            }
            self?.toggleSwitchBabiesView(on: settingsViewController)
        }

        settingsViewController = BabyMonitorGeneralViewController(viewModel: viewModel, type: .settings)
        if let settingsViewController = settingsViewController {
            navigationController.pushViewController(settingsViewController, animated: false)
        }
    }
}

