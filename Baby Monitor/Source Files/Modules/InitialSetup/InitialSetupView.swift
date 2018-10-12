//
//  InitialSetupView.swift
//  Baby Monitor
//


import UIKit

final class InitialSetupView: BaseView {
    
    let cancelItemButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    let startClientButton = UIButton()
    let startServerButton = UIButton()

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [startClientButton, startServerButton])
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 20

        return stackView
    }()
    
    override init() {
        super.init()
        setup()
    }
    
    //MARK: - Private functions
    private func setup() {
        addSubview(buttonsStackView)
        
        setupButtons()
        setupConstraints()
    }
    
    private func setupButtons() {
        //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
        [startClientButton, startServerButton].forEach {
            $0.backgroundColor = .blue
        }
        
        startClientButton.setTitle(Localizable.Onboarding.startClient, for: .normal)
        startServerButton.setTitle(Localizable.Onboarding.startServer, for: .normal)
    }
    
    private func setupConstraints() {        
        buttonsStackView.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.width, multiplier: 0.8),
            $0.equalTo(self, .bottom, .safeAreaBottom, constant: -20)
        ]}
        
        [startClientButton, startServerButton].forEach {
            $0.addConstraints {[
                $0.equalConstant(.width, 150),
                $0.equalConstant(.height, 40),
            ]}
        }
    }
}
