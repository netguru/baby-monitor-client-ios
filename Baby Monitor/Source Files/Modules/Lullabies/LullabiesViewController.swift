//
//  LullabiesViewController.swift
//  Baby Monitor
//


import UIKit

final class LullabiesViewController: BaseViewController {
    
    private let viewModel: LullabiesViewViewModel
    
    init(viewModel: LullabiesViewViewModel) {
        self.viewModel = viewModel
        super.init()
    }
}
