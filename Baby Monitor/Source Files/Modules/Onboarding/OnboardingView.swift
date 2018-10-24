//
//  OnboardingView.swift
//  Baby Monitor
//

import UIKit

final class OnboardingView: BaseView {
    
    enum Role {
        case begin, startDiscovering, clientSetup
    }
    
    private enum Constants {
        static let buttonHeight: CGFloat = 50
        static let logoWidthHegiht: CGFloat = 100
    }
    
    var didSelectFirstAction: (() -> Void)?
    var didSelectSecondAction: (() -> Void)?
    
    private let netguruLogoImageView = UIImageView(image: #imageLiteral(resourceName: "logoNetguru"))
    private let spinner = UIActivityIndicatorView()
    private let firstButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapFirstButton), for: .touchUpInside)
        button.backgroundColor = .blue
        button.titleLabel?.textColor = .white
        return button
    }()
    private let secondButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapSecondButton), for: .touchUpInside)
        button.backgroundColor = .blue
        button.titleLabel?.textColor = .white
        return button
    }()
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstButton, secondButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 20
        return stackView
    }()
    
    init(role: Role) {
        super.init()
        setup(role)
    }
    
    // MARK: - Selectors
    @objc private func didTapFirstButton() {
        didSelectFirstAction?()
    }
    
    @objc private func didTapSecondButton() {
        didSelectSecondAction?()
    }
    
    // MARK: - Private functions
    private func setup(_ role: Role) {
        spinner.isHidden = true
        switch role {
        case .begin:
            firstButton.setTitle(Localizable.Onboarding.startServer, for: .normal)
            secondButton.setTitle(Localizable.Onboarding.startClient, for: .normal)
        case .startDiscovering:
            firstButton.setTitle(Localizable.Onboarding.startDiscovering, for: .normal)
            secondButton.isHidden = true
        case .clientSetup:
            buttonsStackView.isHidden = true
            spinner.isHidden = false
            spinner.style = .gray
            spinner.startAnimating()
        }
        [netguruLogoImageView, spinner, buttonsStackView].forEach {
            addSubview($0)
        }
        [firstButton, secondButton].forEach {
            $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
            $0.layer.cornerRadius = Constants.buttonHeight / 2
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        [firstButton, secondButton].forEach {
            $0.addConstraints {[
                $0.equalConstant(.height, Constants.buttonHeight)
            ]
            }
        }
        netguruLogoImageView.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.centerY),
            $0.equalConstant(.height, Constants.logoWidthHegiht),
            $0.equalConstant(.width, Constants.logoWidthHegiht)
        ]
        }
        spinner.addConstraints {[
            $0.equal(.centerX),
            $0.equalTo(netguruLogoImageView, .top, .bottom, constant: 10)
        ]
        }
        buttonsStackView.addConstraints {[
            $0.equal(.centerX),
            $0.equalTo(spinner, .top, .bottom, constant: 40),
            $0.equal(.width, multiplier: 0.7)
        ]
        }
    }
}
