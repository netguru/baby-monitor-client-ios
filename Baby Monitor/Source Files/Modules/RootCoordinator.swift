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
    
    //Since UITabBarController is used here, navigationController isn't
    var navigationController = UINavigationController()
    
    private let tabBarController = UITabBarController()
    
    init(_ window: UIWindow) {
        self.window = window
        
        setup()
    }
    
    init(_ navigationController: UINavigationController) {
        fatalError("init(navigationController:) is not implemented. Use init(window:) instead")
    }
    
    func start() {
        childCoordinators.forEach { $0.start() }
    }
    
    // MARK: - private functions
    private func setup() {
        let tabViewControllers = childCoordinators.map { $0.navigationController }
        tabBarController.setViewControllers(tabViewControllers, animated: false)
        window.rootViewController = tabBarController
    }
}
