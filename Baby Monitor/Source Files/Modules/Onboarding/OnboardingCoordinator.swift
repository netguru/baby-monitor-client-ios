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
            guard let `self` = self else { return }
            self.showClientSetup()
        }
        initialSetupViewModel.didSelectStartServer = { [weak self] in
            guard let self = self else {
                return
            }
            let viewModel = ServerViewModel(mediaPlayerStreamingService: self.appDependencies.mediaPlayerStreamingService)
            self.navigationController.pushViewController(ServerViewController(viewModel: viewModel), animated: true)
        }
        
        let initialSetupViewController = InitialSetupViewController(viewModel: initialSetupViewModel)
        self.initialSetupViewController = initialSetupViewController
        navigationController.pushViewController(initialSetupViewController, animated: false)
    }
    
    private func showClientSetup() {
        let clientSetupViewModel = ClientSetupViewModel(netServiceClient: self.appDependencies.netServiceClient, rtspConfiguration: self.appDependencies.rtspConfiguration)
        
        let clientSetupViewController = ClientSetupViewController(viewModel: clientSetupViewModel, coordinator: self)
        self.clientSetupViewController = clientSetupViewController
        self.navigationController.pushViewController(clientSetupViewController, animated: true)
    }
    
    func showDashboard() {
        onEnding?()
    }
}
