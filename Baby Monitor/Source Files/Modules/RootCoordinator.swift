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

    func restoreSession() {
        if .baby == UserDefaults.appMode {
            serverCoordinator?.restoreSession()
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
            // This line is extremely important. After resseting the app we may want to establish new
            // WebRTC connection. Thanks to deinitializing and initializing AppDependencies again we are
            // sure that old connection is properly cleared.
            appDependencies = AppDependencies()
            childCoordinators = []
            setup()
            start()
        case .parent, .baby:
            break
        }
    }
}
