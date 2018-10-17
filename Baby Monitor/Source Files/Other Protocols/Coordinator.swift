//
//  Coordinator.swift
//  Baby Monitor
//

import UIKit

protocol RootCoordinatorProtocol: PartialCoordinator, HasWindow {
    init(_ window: UIWindow, appDependencies: AppDependencies)
}

protocol Coordinator: PartialCoordinator, HasNavigationController {
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies)
}

protocol PartialCoordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var appDependencies: AppDependencies { get set }
    
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
