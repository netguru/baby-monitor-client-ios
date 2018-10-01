//
//  Coordinator.swift
//  Baby Monitor
//


import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    init(_ navigationController: UINavigationController)
    
    /// Starts coordinator work. Should be called only once.
    func start()
}

extension Coordinator {
    
    func add(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func remove(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter {
            $0 !== coordinator
        }
    }
}
