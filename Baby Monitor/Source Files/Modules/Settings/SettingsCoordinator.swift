//
//  SettingsCoordinator.swift
//  Baby Monitor
//


import UIKit

final class SettingsCoordinator: Coordinator {
    
    var appDependencies: AppDependencies
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.appDependencies = appDependencies
        self.navigationController = navigationController
    }
    
    func start() {
        showLullabies()
    }
    
    //MARK: - private functions
    private func showLullabies() {
        let viewModel = SettingsViewModel()
        let viewController = SettingsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
}

