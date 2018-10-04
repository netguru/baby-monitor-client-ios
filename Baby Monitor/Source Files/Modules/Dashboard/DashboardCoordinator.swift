//
//  DashboardCoordinator.swift
//  Baby Monitor
//


import UIKit

final class DashboardCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private var dashboardViewController: DashboardViewController?
    private var switchBabyViewController: BabyMonitorGeneralViewController?
    
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
        if let switchBabyViewController = self.switchBabyViewController {
            switchBabyViewController.removeFromParent()
            self.switchBabyViewController = nil
            return
        }
        
        let switchBabyViewModel = SwitchBabyViewModel()
        self.switchBabyViewController = BabyMonitorGeneralViewController(viewModel: switchBabyViewModel, type: .switchBaby)
        dashboardViewController?.addChild(self.switchBabyViewController!)
    }
}
