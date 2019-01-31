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
    
    private weak var onboardingCoordinator: OnboardingCoordinator?
    private weak var dashboardCoordinator: DashboardCoordinator?
    private weak var serverCoordinator: ServerCoordinator?
    
    private let navigationController = UINavigationController()

    init(_ window: UIWindow, appDependencies: AppDependencies) {
        self.window = window
        self.appDependencies = appDependencies
        setup()
    }

    func start() {
        switch UserDefaults.appMode {
        case .parent, .none:
            onboardingCoordinator?.start()
        case .baby:
            serverCoordinator?.start()
        }
    }

    // MARK: - private functions
    private func setup() {
        window.rootViewController = navigationController

        let onboardingCoordinator = OnboardingCoordinator(navigationController, appDependencies: appDependencies)
        self.onboardingCoordinator = onboardingCoordinator
        childCoordinators.append(onboardingCoordinator)
        
        let dashboardCoordinator = DashboardCoordinator(navigationController, appDependencies: appDependencies)
        self.dashboardCoordinator = dashboardCoordinator
        dashboardCoordinator.onEnding = { [unowned self] in
            // For now triggering tabBarCoordinator onEnding is only in situation where user wants to clear all data
            switch UserDefaults.appMode {
            case .none:
                self.childCoordinators = []
                self.setup()
                self.start()
            case .parent, .baby:
                break
            }
        }
        childCoordinators.append(dashboardCoordinator)
        
        let serverCoordinator = ServerCoordinator(navigationController, appDependencies: appDependencies)
        self.serverCoordinator = serverCoordinator
        childCoordinators.append(serverCoordinator)

        onboardingCoordinator.onEnding = { [weak self] in
            switch UserDefaults.appMode {
            case .parent:
                self?.navigationController.setViewControllers([], animated: false)
                dashboardCoordinator.start()
            case .baby:
                serverCoordinator.start()
            case .none:
                break
            }
        }
    }
}
