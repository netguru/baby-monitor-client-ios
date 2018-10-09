//
//  InitialSetupView.swift
//  Baby Monitor
//


import UIKit

final class InitialSetupView: BaseView {
    
    let cancelItemButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [startClientButton, startServerButton])
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 20

        return stackView
    }()
    
    let startClientButton = OnboardingButtonView(text: Localizable.Onboarding.startClient)
    let startServerButton = OnboardingButtonView(text: Localizable.Onboarding.startServer)
    
    override init() {
        super.init()
        setup()
    }
    
    //MARK: - Private functions
    private func setup() {
        addSubview(buttonsStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {        
        buttonsStackView.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.width, multiplier: 0.8),
            $0.equalTo(self, .bottom, .safeAreaBottom, constant: -20)
        ]}
    }
}
