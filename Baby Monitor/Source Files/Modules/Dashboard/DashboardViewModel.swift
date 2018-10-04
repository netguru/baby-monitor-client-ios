//
//  DashboardViewModel.swift
//  Baby Monitor
//


import Foundation

protocol DashboardViewModelCoordinatorDelegate: class {
    
    func didSelectSwitchBaby()
}

final class DashboardViewModel {
    
    weak var coordinatorDelegate: DashboardViewModelCoordinatorDelegate?
    
    func selectSwitchBaby() {
        coordinatorDelegate?.didSelectSwitchBaby()
    }
}

