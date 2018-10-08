//
//  RootCoordinator.swift
//  Baby Monitor
//


import UIKit

final class RootCoordinator: RootCoordinatorProtocol {
    
    var childCoordinators: [Coordinator] = [
        DashboardCoordinator(UINavigationController()),
        ActivityLogCoordinator(UINavigationController()),
        LullabiesCoordinator(UINavigationController()),
        SettingsCoordinator(UINavigationController())
    ]
    
    var window: UIWindow
    
    private let tabBarController = TabBarController()
    
    init(_ window: UIWindow) {
        self.window = window
        
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
