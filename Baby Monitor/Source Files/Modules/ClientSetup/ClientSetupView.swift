//
//  ClientSetupView.swift
//  Baby Monitor
//


import UIKit

final class ClientSetupView: BaseView {
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [setupAddressButton, startDiscoveringButton])
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 20
        
        return stackView
    }()
    
    let setupAddressButton = OnboardingButtonView(text: Localizable.Onboarding.setupAddress)
    let startDiscoveringButton = OnboardingButtonView(text: Localizable.Onboarding.startDiscovering)
    lazy var addressField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Localizable.Onboarding.addressPlaceholder
        
        return textField
    }()
    
    override init() {
        super.init()
        setup()
    }
    
    //MARK: - Private functions
    private func setup() {
        [addressField, buttonsStackView].forEach {
            addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        buttonsStackView.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.width, multiplier: 0.8),
            $0.equalTo(self, .bottom, .safeAreaBottom, constant: -20)
        ]}
        
        addressField.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.centerY),
            $0.equalConstant(.height, 50),
            $0.equalConstant(.width, 150),
        ]}
    }
}
