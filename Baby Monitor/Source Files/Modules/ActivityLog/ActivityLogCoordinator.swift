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

    private var activityLogViewController: ActivityLogViewController?
    
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.appDependencies = appDependencies
        self.navigationController = navigationController
    }
    
    func start() {
        showActivityLog()
    }
    
    // MARK: - private functions
    private func showActivityLog() {
        let viewModel = ActivityLogViewModel(babyService: appDependencies.babyService)
        viewModel.didSelectShowBabies = { [weak self] in
            guard let self = self, let activityLogViewController = self.activityLogViewController else {
                return
            }
            self.toggleSwitchBabiesView(on: activityLogViewController, babyService: self.appDependencies.babyService)
        }
        activityLogViewController = ActivityLogViewController(viewModel: viewModel)
        navigationController.pushViewController(activityLogViewController!, animated: false)
    }
}
