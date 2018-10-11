//
//  RootCoordinator.swift
//  Baby Monitor
//


import UIKit

final class RootCoordinator: RootCoordinatorProtocol {

    var onEnding: (() -> Void)?
    
    enum Launch {
        case first
        case next
    }

    var launch = Launch.first

    var childCoordinators: [Coordinator] = []
    private let navigationController = UINavigationController()

    var window: UIWindow

    init(_ window: UIWindow) {
        self.window = window

        setup()
    }

    func start() {
        switch launch {
        case .first:
            childCoordinators[0].start()
        case .next:
            childCoordinators[1].start()
        }
    }

    // MARK: - private functions
    private func setup() {
        window.rootViewController = navigationController

        let onboardingCoordinator = OnboardingCoordinator(navigationController)
        childCoordinators.append(onboardingCoordinator)
        
        let tabBarCoordinator = TabBarCoordinator(navigationController)
        childCoordinators.append(tabBarCoordinator)

        onboardingCoordinator.onEnding = { [weak self] in
            self?.navigationController.setViewControllers([], animated: false)
            tabBarCoordinator.start()
        }
    }
}
