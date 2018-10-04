//
//  DashboardCoordinator.swift
//  Baby Monitor
//


import UIKit

final class DashboardCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private var dashboardViewController: DashboardViewController?
    private var switchBabyTableViewController: SwitchBabyViewController?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showDashboard()
    }
    
    private func showDashboard() {
        let viewModel = DashboardViewViewModel()
        viewModel.coordinatorDelegate = self
        dashboardViewController = DashboardViewController(viewModel: viewModel)
        navigationController.pushViewController(dashboardViewController!, animated: false)
    }
}

//MARK: - DashboardViewViewModelCoordinatorDelegate
extension DashboardCoordinator: DashboardViewViewModelCoordinatorDelegate {
    
    func didSelectShowBabies() {
        if let switchBabyTableViewController = switchBabyTableViewController {
            switchBabyTableViewController.removeFromParent()
            self.switchBabyTableViewController = nil
            return
        }
        
        let switchBabyTableViewViewModel = SwitchBabyTableViewViewModel()
        self.switchBabyTableViewController = SwitchBabyViewController(viewModel: switchBabyTableViewViewModel)
        dashboardViewController?.addChild(self.switchBabyTableViewController!)
    }
}
