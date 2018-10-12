//
//  SettingsCoordinator.swift
//  Baby Monitor
//


import UIKit

final class SettingsCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var onEnding: (() -> Void)?
    
    init(_ navigationController: UINavigationController) {
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

