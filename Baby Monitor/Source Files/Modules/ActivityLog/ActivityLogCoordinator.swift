//
//  ActivityLogCoordinator.swift
//  Baby Monitor
//


import UIKit

final class ActivityLogCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private var switchBabyTableViewController: BabyMonitorGeneralViewController?
    private var activityLogViewController: BabyMonitorGeneralViewController?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showActivityLog()
    }
    
    //MARK: - private functions
    private func showActivityLog() {
        let viewModel = ActivityLogViewModel()
        viewModel.coordinatorDelegate = self
        activityLogViewController = BabyMonitorGeneralViewController(viewModel: viewModel, type: .activityLog)
        navigationController.pushViewController(activityLogViewController!, animated: false)
    }
}

extension ActivityLogCoordinator: ActivityLogViewModelCoordinatorDelegate {
    
    func didSelectShowBabies() {
        if let switchBabyTableViewController = switchBabyTableViewController {
            switchBabyTableViewController.removeFromParent()
            self.switchBabyTableViewController = nil
            return
        }
        
        let switchBabyTableViewViewModel = SwitchBabyViewModel()
        self.switchBabyTableViewController = BabyMonitorGeneralViewController(viewModel: switchBabyTableViewViewModel, type: .switchBaby)
        activityLogViewController?.addChild(self.switchBabyTableViewController!)
    }
}
