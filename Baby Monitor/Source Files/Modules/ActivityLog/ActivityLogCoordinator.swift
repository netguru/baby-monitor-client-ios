//
//  ActivityLogCoordinator.swift
//  Baby Monitor
//

import UIKit

final class ActivityLogCoordinator: Coordinator, BabiesViewShowable {
    
    var appDependencies: AppDependencies
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var switchBabyViewController: BabyMonitorGeneralViewController?
    
    var onEnding: (() -> Void)?

    private var activityLogViewController: BabyMonitorGeneralViewController?
    
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.appDependencies = appDependencies
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
