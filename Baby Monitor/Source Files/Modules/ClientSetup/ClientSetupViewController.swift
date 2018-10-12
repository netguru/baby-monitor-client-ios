//
//  ClientSetupViewController.swift
//  Baby Monitor
//


import UIKit

final class ClientSetupViewController: TypedViewController<ClientSetupView>, UITextFieldDelegate {
    
    private let viewModel: ClientSetupViewModel
    
    init(viewModel: ClientSetupViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: ClientSetupView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Private functions
    private func setup() {
        customView.setupAddressButton.onSelect = { [weak self] in
            self?.viewModel.selectSetupAddress(self?.customView.addressField.text)
        }
        customView.startDiscoveringButton.onSelect = { [weak self] in
            self?.viewModel.selectStartDiscovering()
        }
        
        customView.addressField.delegate = self
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        customView.endEditing(true)
        return false
    }
}
