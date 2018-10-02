//
//  ActivityLogViewController.swift
//  Baby Monitor
//


import UIKit

final class ActivityLogViewController: BaseViewController {
    
    private let viewModel: ActivityLogViewViewModel
    
    init(viewModel: ActivityLogViewViewModel) {
        self.viewModel = viewModel
        super.init()
    }
}
