//
//  DashboardViewViewModel.swift
//  Baby Monitor
//


import Foundation

protocol DashboardViewViewModelCoordinatorDelegate: class {
    
    func didSelectSwitchBaby()
}

final class DashboardViewViewModel {
    
    weak var coordinatorDelegate: DashboardViewViewModelCoordinatorDelegate?
    
    func selectSwitchBaby() {
        coordinatorDelegate?.didSelectSwitchBaby()
    }
}

