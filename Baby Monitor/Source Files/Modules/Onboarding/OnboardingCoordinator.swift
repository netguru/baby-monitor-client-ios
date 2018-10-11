//
//  OnboardingCoordinator.swift
//  Baby Monitor
//


import UIKit

final class OnboardingCoordinator: Coordinator {

    var onEnding: (() -> Void)?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private weak var initialSetupViewController: InitialSetupViewController?
    private weak var clientSetupViewController: ClientSetupViewController?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showInitialSetup()
    }
    
    private func showInitialSetup() {
        let initialSetupViewModel = InitialSetupViewModel()
        
        initialSetupViewModel.didSelectStartClient = { [weak self] in
            let clientSetupViewModel = ClientSetupViewModel()
            clientSetupViewModel.didSelectSetupAddress = { (address) in
                //TODO: Connect to the address
            }
            clientSetupViewModel.didSelectStartDiscovering = {
                //TODO: Search for devices and connect
                
                self?.onEnding?()
            }
            
            let clientSetupViewController = ClientSetupViewController(viewModel: clientSetupViewModel)
            self?.clientSetupViewController = clientSetupViewController
            self?.navigationController.pushViewController(clientSetupViewController, animated: true)
        }
        initialSetupViewModel.didSelectStartServer = {
            //TODO: Start broadcasting
        }

        let initialSetupViewController = InitialSetupViewController(viewModel: initialSetupViewModel)
        self.initialSetupViewController = initialSetupViewController
        navigationController.pushViewController(initialSetupViewController, animated: false)
    }
}
