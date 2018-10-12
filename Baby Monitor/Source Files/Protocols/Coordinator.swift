//
//  Coordinator.swift
//  Baby Monitor
//


import UIKit

typealias RootCoordinatorProtocol = PartialCoordinator & WindowInitializable
typealias Coordinator = PartialCoordinator & NavigationControllerInitializable

protocol PartialCoordinator: class {
    var childCoordinators: [Coordinator] { get set }
    
    var onEnding: (() -> Void)? { get set }
    
    /// Starts coordinator work. Should be called only once.
    func start()
}

extension PartialCoordinator {
    
    func add(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func remove(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter {
            $0 !== coordinator
        }
    }
}
