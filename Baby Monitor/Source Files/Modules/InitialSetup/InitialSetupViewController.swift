//
//  InitialSetupViewController.swift
//  Baby Monitor
//


import UIKit

final class InitialSetupViewController: TypedViewController<InitialSetupView> {
    
    private let viewModel: InitialSetupViewModel
    
    init(viewModel: InitialSetupViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: InitialSetupView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Private functions
    private func setup() {
        customView.startClientButton.onSelect = { [weak self] in
            self?.viewModel.selectStartClient()
        }
        customView.startServerButton.onSelect = { [weak self] in
            self?.viewModel.selectStartServer()
        }
    }
}
