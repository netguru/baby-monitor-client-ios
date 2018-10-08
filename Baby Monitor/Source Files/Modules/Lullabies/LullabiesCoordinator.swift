//
//  LullabiesCoordinator.swift
//  Baby Monitor
//


import UIKit

final class LullabiesCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    private var lullabiesViewController: BabyMonitorGeneralViewController?
    private var switchBabyViewController: BabyMonitorGeneralViewController?
    
    func start() {
        showLullabies()
    }
    
    //MARK: - private functions
    private func showLullabies() {
        let viewModel = LullabiesViewModel()
        viewModel.coordinatorDelegate = self
        lullabiesViewController = BabyMonitorGeneralViewController(viewModel: viewModel, type: .lullaby)
        navigationController.pushViewController(lullabiesViewController!, animated: false)
    }
}

// MARK: - LullabiesViewModelCoordinatorDelegate
extension LullabiesCoordinator: LullabiesViewModelCoordinatorDelegate {
    
    func didSelectShowBabiesView() {
        if let switchBabyViewController = switchBabyViewController {
            switchBabyViewController.removeFromParent()
            self.switchBabyViewController = nil
            return
        }
        
        let switchBabyViewModel = SwitchBabyViewModel()
        self.switchBabyViewController = BabyMonitorGeneralViewController(viewModel: switchBabyViewModel, type: .switchBaby)
        lullabiesViewController?.addChild(self.switchBabyViewController!)
    }
}
