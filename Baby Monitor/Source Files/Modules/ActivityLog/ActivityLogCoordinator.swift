//
//  ActivityLogCoordinator.swift
//  Baby Monitor
//


import UIKit

final class ActivityLogCoordinator: Coordinator, BabiesViewShowable {

    var onEnding: (() -> Void)?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var switchBabyViewController: BabyMonitorGeneralViewController?
    
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
        viewModel.didSelectShowBabies = { [weak self] in
            guard let activityLogViewController = self?.activityLogViewController else {
                return
            }
            self?.toggleSwitchBabiesView(on: activityLogViewController)
        }
        activityLogViewController = BabyMonitorGeneralViewController(viewModel: viewModel, type: .activityLog)
        navigationController.pushViewController(activityLogViewController!, animated: false)
    }
}
