//
//  RootCoordinator.swift
//  Baby Monitor
//

import UIKit

final class RootCoordinator: RootCoordinatorProtocol {
    
    var childCoordinators: [Coordinator] = []
    var onEnding: (() -> Void)?

    var window: UIWindow
    var appDependencies: AppDependencies
    
    private let navigationController = UINavigationController()

    init(_ window: UIWindow, appDependencies: AppDependencies) {
        self.window = window
        self.appDependencies = appDependencies
        setup()
    }

    func start() {
        childCoordinators.first?.start()
    }

    // MARK: - private functions
    private func setup() {
        window.rootViewController = navigationController
        
        let introCoordinator = IntroCoordinator(navigationController, appDependencies: appDependencies)
        childCoordinators.append(introCoordinator)

        let onboardingCoordinator = OnboardingCoordinator(navigationController, appDependencies: appDependencies)
        childCoordinators.append(onboardingCoordinator)
        
        let tabBarCoordinator = TabBarCoordinator(navigationController, appDependencies: appDependencies)
        childCoordinators.append(tabBarCoordinator)

        introCoordinator.onEnding = {
            onboardingCoordinator.start()
        }
        onboardingCoordinator.onEnding = { [weak self] in
            self?.navigationController.setViewControllers([], animated: false)
            tabBarCoordinator.start()
        }
    }
}
