//
//  SettingsViewController.swift
//  Baby Monitor
//


import UIKit

final class SettingsViewController: BaseViewController {
    
    private let viewModel: SettingsViewViewModel
    
    init(viewModel: SettingsViewViewModel) {
        self.viewModel = viewModel
        super.init()
    }
}
