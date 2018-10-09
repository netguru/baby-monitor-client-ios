//
//  OnboardingCoordinator.swift
//  Baby Monitor
//


import UIKit

final class OnboardingCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = [
        TabBarCoordinator(UINavigationController())
    ]
    var navigationController: UINavigationController
    
    private weak var initialSetupViewController: InitialSetupViewController?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showInitialSetup()
    }
    
    private func showInitialSetup() {
        let viewModel = InitialSetupViewModel()
        
        viewModel.didSelectStartClient = { [weak self] in
            self?.childCoordinators.first?.start()
            self?.navigationController.present((self?.childCoordinators.first as! TabBarCoordinator).tabBarController, animated: true, completion: nil)
        }
//        viewModel.didSelectStartServer = { [weak self] in
//
//        }

        let initialSetupViewController = InitialSetupViewController(viewModel: viewModel)
        self.initialSetupViewController = initialSetupViewController
        navigationController.pushViewController(initialSetupViewController, animated: false)
    }
}
