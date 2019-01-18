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
    
    private weak var pairingCoordinator: OnboardingPairingCoordinator?
    private weak var connectingCoordinator: OnboardingConnectingCoordinator?
    
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
        setup()
    }

    func start() {
        childCoordinators.first?.start()
    }
    
    private func setup() {
        let introCoordinator = IntroCoordinator(navigationController, appDependencies: appDependencies)
        childCoordinators.append(introCoordinator)
        introCoordinator.onEnding = { [weak self] in
            self?.showInitialSetup()
        }
        navigationController.setNavigationBarHidden(true, animated: false)
        let pairingCoordinator = OnboardingPairingCoordinator(navigationController, appDependencies: appDependencies)
        pairingCoordinator.onEnding = { [weak self] in
            UserDefaults.appMode = .parent
            self?.onEnding?()
        }
        childCoordinators.append(pairingCoordinator)
        self.pairingCoordinator = pairingCoordinator
        let connectingCoordinator = OnboardingConnectingCoordinator(navigationController, appDependencies: appDependencies)
        connectingCoordinator.onEnding = { [weak self] in
            UserDefaults.appMode = .baby
            self?.onEnding?()
        }
        childCoordinators.append(connectingCoordinator)
        self.connectingCoordinator = connectingCoordinator
    }

    private func showInitialSetup() {
        let viewModel = SpecifyDeviceOnboardingViewModel()
        viewModel.didSelectBaby = { [weak self] in
            self?.connectingCoordinator?.start()
        }
        viewModel.didSelectParent = { [weak self] in
            self?.pairingCoordinator?.start()
        }
        let viewController = SpecifyDeviceOnboardingViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
