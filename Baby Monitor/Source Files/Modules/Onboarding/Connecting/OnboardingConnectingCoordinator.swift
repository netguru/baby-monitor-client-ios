//
//  OnboardingConnectingCoordinator.swift
//  Baby Monitor
//

import Foundation
import UIKit

final class OnboardingConnectingCoordinator: Coordinator {
    
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
    }
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var appDependencies: AppDependencies
    var onEnding: (() -> Void)?
    
    func start() {
        showConnectToWiFiView()
    }
    
    private func showConnectToWiFiView() {
        let viewModel = OnboardingContinuableViewModel()
        viewModel.onSelectNext = { [weak self] in
            self?.showSetupInformationView()
        }
        let viewController = OnboardingContinuableViewController(role: .connecting(.connectToWiFi), viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showSetupInformationView() {
        let viewModel = OnboardingContinuableViewModel()
        viewModel.onSelectNext = { [weak self] in
            self?.onEnding?()
        }
        let viewController = OnboardingContinuableViewController(role: .connecting(.setupInformation), viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
