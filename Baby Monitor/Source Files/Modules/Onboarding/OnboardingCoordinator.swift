//
//  OnboardingCoordinator.swift
//  Baby Monitor
//


import UIKit

final class OnboardingCoordinator: Coordinator {
    
    var appDependencies: AppDependencies
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var onEnding: (() -> Void)?
    
    private weak var initialSetupViewController: InitialSetupViewController?
    private weak var clientSetupViewController: ClientSetupViewController?
    
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
    }
    
    func start() {
        showInitialSetup()
    }
    
    private func showInitialSetup() {
        let initialSetupViewModel = InitialSetupViewModel()
        
        initialSetupViewModel.didSelectStartClient = { [weak self] in
            let clientSetupViewModel = ClientSetupViewModel()
            clientSetupViewModel.didSelectSetupAddress = { (address) in
                //TODO: Connect to the address, ticket: https://netguru.atlassian.net/browse/BM-80
            }
            clientSetupViewModel.didSelectStartDiscovering = {
                //TODO: Search for devices and connect, ticket: https://netguru.atlassian.net/browse/BM-79
                
                self?.onEnding?()
            }
            
            let clientSetupViewController = ClientSetupViewController(viewModel: clientSetupViewModel)
            self?.clientSetupViewController = clientSetupViewController
            self?.navigationController.pushViewController(clientSetupViewController, animated: true)
        }
        initialSetupViewModel.didSelectStartServer = {
            //TODO: Start broadcasting, ticket: https://netguru.atlassian.net/browse/BM-60
        }

        let initialSetupViewController = InitialSetupViewController(viewModel: initialSetupViewModel)
        self.initialSetupViewController = initialSetupViewController
        navigationController.pushViewController(initialSetupViewController, animated: false)
    }
}
