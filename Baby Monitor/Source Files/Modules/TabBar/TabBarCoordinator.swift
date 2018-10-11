//
//  TabBarCoordinator.swift
//  Baby Monitor
//


import UIKit

final class TabBarCoordinator: Coordinator {

    var onEnding: (() -> Void)?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = [
        DashboardCoordinator(UINavigationController()),
        ActivityLogCoordinator(UINavigationController()),
        LullabiesCoordinator(UINavigationController()),
        SettingsCoordinator(UINavigationController())
    ]
    
    let tabBarController = TabBarController()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        setup()
    }
    
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
