//
//  LullabiesCoordinator.swift
//  Baby Monitor
//


import UIKit

final class LullabiesCoordinator: Coordinator, BabiesViewShowable {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var switchBabyViewController: BabyMonitorGeneralViewController?
    
    private var lullabiesViewController: BabyMonitorGeneralViewController?
    
    var onEnding: (() -> Void)?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLullabies()
    }
    
    //MARK: - private functions
    private func showLullabies() {
        let viewModel = LullabiesViewModel()
        viewModel.didSelectShowBabiesView = { [weak self] in
            guard let lullabiesViewController = self?.lullabiesViewController else {
                return
            }
            self?.toggleSwitchBabiesView(on: lullabiesViewController)
        }
        lullabiesViewController = BabyMonitorGeneralViewController(viewModel: viewModel, type: .lullaby)
        navigationController.pushViewController(lullabiesViewController!, animated: false)
    }
}
