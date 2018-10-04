//
//  DashboardViewModel.swift
//  Baby Monitor
//


import Foundation

/// Protocol for coordinator delegate of Dashboard view
protocol DashboardViewModelCoordinatorDelegate: class {
    
    /// Function that informs coordinator delegate about selecting show babies action
    func didSelectShowBabies()
}

final class DashboardViewModel {
    
    weak var coordinatorDelegate: DashboardViewModelCoordinatorDelegate?
    
    func selectSwitchBaby() {
        coordinatorDelegate?.didSelectShowBabies()
    }
}

