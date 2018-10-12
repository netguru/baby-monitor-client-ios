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
    
    //MARK: - Selectors
    @objc private func didTouchSetupAddressButton() {
        viewModel.selectSetupAddress(customView.addressField.text)
    }
    
    @objc private func didTouchStartDiscoveringButton() {
        viewModel.selectStartDiscovering()
    }
    
    //MARK: - Private functions
    private func setup() {
        customView.setupAddressButton.addTarget(self, action: #selector(didTouchSetupAddressButton), for: .touchUpInside)
        customView.startDiscoveringButton.addTarget(self, action: #selector(didTouchStartDiscoveringButton), for: .touchUpInside)
        
        customView.addressField.delegate = self
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        customView.endEditing(true)
        return false
    }
}
