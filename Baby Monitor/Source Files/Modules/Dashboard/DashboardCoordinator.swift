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
        let viewModel = DashboardViewModel()
        viewModel.coordinatorDelegate = self
        dashboardViewController = DashboardViewController(viewModel: viewModel)
        navigationController.pushViewController(dashboardViewController!, animated: false)
    }
}

//MARK: - DashboardViewModelCoordinatorDelegate
extension DashboardCoordinator: DashboardViewModelCoordinatorDelegate {
    
    func didSelectShowBabies() {
        if let switchBabyTableViewController = switchBabyTableViewController {
            switchBabyTableViewController.removeFromParent()
            self.switchBabyTableViewController = nil
            return
        }
        
        let switchBabyTableViewViewModel = SwitchBabyTableViewModel()
        self.switchBabyTableViewController = SwitchBabyViewController(viewModel: switchBabyTableViewViewModel)
        dashboardViewController?.addChild(self.switchBabyTableViewController!)
    }
}
