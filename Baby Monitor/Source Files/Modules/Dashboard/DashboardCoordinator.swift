//
//  DashboardCoordinator.swift
//  Baby Monitor
//


import UIKit

final class DashboardCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private var dashboardViewController: DashboardViewController?
    private var switchBabyTableViewController: BabyMonitorGeneralViewController?
    
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

//MARK: - DashboardViewViewModelCoordinatorDelegate
extension DashboardCoordinator: DashboardViewModelCoordinatorDelegate {
    
    func didSelectSwitchBaby() {
        if let switchBabyTableViewController = switchBabyTableViewController {
            switchBabyTableViewController.remove()
            self.switchBabyTableViewController = nil
            return
        }
        
        let switchBabyTableViewViewModel = SwitchBabyViewModel()
        self.switchBabyTableViewController = BabyMonitorGeneralViewController(viewModel: switchBabyTableViewViewModel, type: .switchBaby)
        dashboardViewController?.add(self.switchBabyTableViewController!)
    }
}
