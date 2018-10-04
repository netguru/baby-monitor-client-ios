//
//  SettingsViewController.swift
//  Baby Monitor
//


import UIKit

final class SettingsViewController: BaseViewController {
    
    private let viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
}
