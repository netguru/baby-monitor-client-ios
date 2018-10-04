//
//  ActivityLogViewController.swift
//  Baby Monitor
//


import UIKit

final class ActivityLogViewController: BaseViewController {
    
    private let viewModel: ActivityLogViewModel
    
    init(viewModel: ActivityLogViewModel) {
        self.viewModel = viewModel
        super.init()
    }
}
