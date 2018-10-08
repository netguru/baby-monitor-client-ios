//
//  ActivityLogCoordinator.swift
//  Baby Monitor
//


import UIKit

final class ActivityLogCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private var switchBabyViewController: BabyMonitorGeneralViewController?
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
        if let switchBabyViewController = switchBabyViewController {
            switchBabyViewController.removeFromParent()
            self.switchBabyViewController = nil
            return
        }
        
        let switchBabyViewModel = SwitchBabyViewModel()
        self.switchBabyViewController = BabyMonitorGeneralViewController(viewModel: switchBabyViewModel, type: .switchBaby)
        activityLogViewController?.addChild(self.switchBabyViewController!)
    }
}
