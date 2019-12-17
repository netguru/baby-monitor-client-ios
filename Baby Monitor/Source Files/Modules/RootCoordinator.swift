//
//  RootCoordinator.swift
//  Baby Monitor
//

import UIKit

final class RootCoordinator: RootCoordinatorProtocol {
    
    var childCoordinators: [Coordinator] = []
    var onEnding: (() -> Void)?
    var onReset: (() -> Void)?
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
        case .parent:
            dashboardCoordinator?.start()
        case .none:
            onboardingCoordinator?.start()
        case .baby:
            serverCoordinator?.start()
        }
    }

    func update(dependencies: AppDependencies) {
        self.appDependencies = dependencies
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
            self.triggerOnEndingForDashboardAndServerCoordinator()
        }
        childCoordinators.append(dashboardCoordinator)
        
        let serverCoordinator = ServerCoordinator(navigationController, appDependencies: appDependencies)
        self.serverCoordinator = serverCoordinator
        serverCoordinator.onEnding = { [unowned self] in
            self.triggerOnEndingForDashboardAndServerCoordinator()
        }
        childCoordinators.append(serverCoordinator)
        onboardingCoordinator.onEnding = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                switch UserDefaults.appMode {
                case .parent:
                    dashboardCoordinator.start()
                case .baby:
                    serverCoordinator.start()
                case .none:
                    break
                }
            })
        }
    }
    
    private func triggerOnEndingForDashboardAndServerCoordinator() {
        // For now triggering dashboardCoordinator/serverCoordinator onEnding is only in situation where user wants to clear all data
        switch UserDefaults.appMode {
        case .none:
            onReset?()
            childCoordinators = []
            setup()
            start()
        case .parent, .baby:
            break
        }
    }
}
