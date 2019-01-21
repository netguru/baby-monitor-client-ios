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
    private weak var tabBarCoordinator: TabBarCoordinator?
    private weak var serverCoordinator: ServerCoordinator?
    
    private let navigationController = UINavigationController()

    init(_ window: UIWindow, appDependencies: AppDependencies) {
        self.window = window
        self.appDependencies = appDependencies
        setup()
    }

    func start() {
        switch UserDefaults.appMode {
        case .parent, .baby:
            onboardingCoordinator?.start()
        case .none:
            onboardingCoordinator?.start()
        }
    }

    // MARK: - private functions
    private func setup() {
        window.rootViewController = navigationController

        let onboardingCoordinator = OnboardingCoordinator(navigationController, appDependencies: appDependencies)
        self.onboardingCoordinator = onboardingCoordinator
        childCoordinators.append(onboardingCoordinator)
        
        let tabBarCoordinator = TabBarCoordinator(navigationController, appDependencies: appDependencies)
        self.tabBarCoordinator = tabBarCoordinator
        tabBarCoordinator.onEnding = { [unowned self] in
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
        childCoordinators.append(tabBarCoordinator)
        
        let serverCoordinator = ServerCoordinator(navigationController, appDependencies: appDependencies)
        self.serverCoordinator = serverCoordinator
        childCoordinators.append(serverCoordinator)

        onboardingCoordinator.onEnding = { [weak self] in
            switch UserDefaults.appMode {
            case .parent:
                self?.navigationController.setViewControllers([], animated: false)
                tabBarCoordinator.start()
            case .baby:
                serverCoordinator.start()
            case .none:
                fatalError("Here should not be selected `.none`")
            }
        }
    }
}
