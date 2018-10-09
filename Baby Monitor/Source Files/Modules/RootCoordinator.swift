//
//  RootCoordinator.swift
//  Baby Monitor
//


import UIKit

final class RootCoordinator: RootCoordinatorProtocol {

    enum Launch {
        case first
        case next
    }

    var launch = Launch.first

    var childCoordinators: [Coordinator] = [
        OnboardingCoordinator(UINavigationController()),
        TabBarCoordinator(UINavigationController())
    ]

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
        switch launch {
        case .first:
            window.rootViewController = childCoordinators[0].navigationController
        case .next:
            window.rootViewController = (childCoordinators[1] as! TabBarCoordinator).tabBarController
        }
    }
}
