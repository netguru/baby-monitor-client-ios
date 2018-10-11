//
//  RootCoordinator.swift
//  Baby Monitor
//


import UIKit

final class RootCoordinator: RootCoordinatorProtocol {
    
    var appDependencies: AppDependencies
    lazy var childCoordinators: [Coordinator] = [
        DashboardCoordinator(UINavigationController(), appDependencies: appDependencies),
        ActivityLogCoordinator(UINavigationController(), appDependencies: appDependencies),
        LullabiesCoordinator(UINavigationController(), appDependencies: appDependencies),
        SettingsCoordinator(UINavigationController(), appDependencies: appDependencies)
    ]
    
    var window: UIWindow
    
    private let tabBarController = TabBarController()
    
    init(_ window: UIWindow, appDependencies: AppDependencies) {
        self.window = window
        self.appDependencies = appDependencies
        setup()
    }
    
    func start() {
        childCoordinators.forEach { $0.start() }
    }
    
    // MARK: - private functions
    private func setup() {
        let tabViewControllers = childCoordinators.map { $0.navigationController }
        tabBarController.setViewControllers(tabViewControllers, animated: false)
        tabBarController.setupTitles()
        window.rootViewController = tabBarController
    }
}
