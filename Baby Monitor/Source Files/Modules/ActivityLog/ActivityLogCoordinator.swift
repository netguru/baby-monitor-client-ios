//
//  ActivityLogCoordinator.swift
//  Baby Monitor
//


import UIKit

final class ActivityLogCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showActivityLog()
    }
    
    //MARK: - private functions
    private func showActivityLog() {
        let viewModel = ActivityLogViewViewModel()
        let viewController = ActivityLogViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
}
