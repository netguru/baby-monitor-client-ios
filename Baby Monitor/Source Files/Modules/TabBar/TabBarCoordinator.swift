//
//  TabBarCoordinator.swift
//  Baby Monitor
//

import UIKit

final class TabBarCoordinator: Coordinator {
    
    var appDependencies: AppDependencies
    var navigationController: UINavigationController
    lazy var childCoordinators: [Coordinator] = [
        DashboardCoordinator(UINavigationController(), appDependencies: appDependencies),
        ActivityLogCoordinator(UINavigationController(), appDependencies: appDependencies),
        // TODO: Hidden for MVP
        // LullabiesCoordinator(UINavigationController(), appDependencies: appDependencies),
        SettingsCoordinator(UINavigationController(), appDependencies: appDependencies)
    ]
    var onEnding: (() -> Void)?
    
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
        setup()
    }
    
    private let tabBarController = TabBarController()
    
    func start() {
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(tabBarController, animated: true)
        childCoordinators.forEach { $0.start() }
    }
    
    // MARK: - private functions
    private func setup() {
        let tabViewControllers = childCoordinators.map { $0.navigationController }
        tabBarController.setViewControllers(tabViewControllers, animated: false)
        tabBarController.setupTitles()
    }
}
