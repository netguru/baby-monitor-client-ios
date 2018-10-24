//
//  LullabiesCoordinator.swift
//  Baby Monitor
//

import UIKit

final class LullabiesCoordinator: Coordinator, BabiesViewShowable {
    
    var appDependencies: AppDependencies
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var switchBabyViewController: BabyMonitorGeneralViewController?
    var onEnding: (() -> Void)?
    
    private var lullabiesViewController: LullabiesViewController?
    
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
    }
    
    func start() {
        showLullabies()
    }
    
    // MARK: - private functions
    private func showLullabies() {
        let viewModel = LullabiesViewModel(babyRepo: appDependencies.babyRepo)
        viewModel.didSelectShowBabiesView = { [weak self] in
            guard let self = self, let lullabiesViewController = self.lullabiesViewController else {
                return
            }
            self.toggleSwitchBabiesView(on: lullabiesViewController, babyRepo: self.appDependencies.babyRepo)
        }
        lullabiesViewController = LullabiesViewController(viewModel: viewModel)
        navigationController.pushViewController(lullabiesViewController!, animated: false)
    }
}
