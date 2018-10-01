//
//  RootCoordinator.swift
//  Baby Monitor
//


import UIKit

final class RootCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
}
