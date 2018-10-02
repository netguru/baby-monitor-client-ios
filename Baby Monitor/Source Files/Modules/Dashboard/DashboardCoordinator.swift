//
//  DashboardCoordinator.swift
//  Baby Monitor
//


import UIKit

final class DashboardCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showDashboard()
    }
    
    private func showDashboard() {
        let viewModel = DashboardViewViewModel()
        let dashboardViewController = DashboardViewController(viewModel: viewModel)
        navigationController.setViewControllers([dashboardViewController], animated: false)
    }
}
