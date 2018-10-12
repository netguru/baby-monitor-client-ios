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
    
    //MARK: - Selectors
    @objc private func didTouchstartClientButton() {
        viewModel.selectStartClient()
    }
    
    @objc private func didTouchStartServerButton() {
        viewModel.selectStartServer()
    }
    
    //MARK: - Private functions
    private func setup() {
        customView.startClientButton.addTarget(self, action: #selector(didTouchstartClientButton), for: .touchUpInside)
        customView.startServerButton.addTarget(self, action: #selector(didTouchStartServerButton), for: .touchUpInside)
    }
}
