//
//  OnboardingPairingCoordinator.swift
//  Baby Monitor
//

import Foundation

final class OnboardingPairingCoordinator: Coordinator {
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
    }
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var appDependencies: AppDependencies
    var onEnding: (() -> Void)?
    
    func start() {
        showInstallBMOnSecondDeviceView()
    }
    
    private func showInstallBMOnSecondDeviceView() {
        let viewModel = OnboardingContinuableViewModel()
        viewModel.onSelectNext = {
            self.showConnectingView()
        }
        let viewController = OnboardingContinuableViewController(role: .pairing(.shareLink), viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showConnectingView() {
        showPairingDoneView()
    }
    
    private func showPairingDoneView() {
        let viewModel = OnboardingContinuableViewModel()
        viewModel.onSelectNext = {
            self.showAllDoneView()
        }
        let viewController = OnboardingContinuableViewController(role: .pairing(.pairingDone), viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showAllDoneView() {
        let viewModel = OnboardingContinuableViewModel()
        viewModel.onSelectNext = {
            self.onEnding?()
        }
        let viewController = OnboardingContinuableViewController(role: .pairing(.allDone), viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
