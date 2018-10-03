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
    
    func start() {
        showLullabies()
    }
    
    //MARK: - private functions
    private func showLullabies() {
        let viewModel = LullabiesViewViewModel()
        let viewController = LullabiesViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
}
