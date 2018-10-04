//
//  DashboardViewViewModel.swift
//  Baby Monitor
//


import Foundation

/// Protocol for coordinator delegate of Dashboard view
protocol DashboardViewViewModelCoordinatorDelegate: class {
    
    /// Function that informs coordinator delegate about selecting show babies action
    func didSelectShowBabies()
}

final class DashboardViewViewModel {
    
    weak var coordinatorDelegate: DashboardViewViewModelCoordinatorDelegate?
    
    func selectSwitchBaby() {
        coordinatorDelegate?.didSelectShowBabies()
    }
}

