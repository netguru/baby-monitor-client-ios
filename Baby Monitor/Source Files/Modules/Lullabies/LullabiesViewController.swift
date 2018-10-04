//
//  LullabiesViewController.swift
//  Baby Monitor
//


import UIKit

final class LullabiesViewController: BaseViewController {
    
    private let viewModel: LullabiesViewModel
    
    init(viewModel: LullabiesViewModel) {
        self.viewModel = viewModel
        super.init()
    }
}
