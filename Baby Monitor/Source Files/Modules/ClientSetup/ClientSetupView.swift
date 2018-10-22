//
//  ClientSetupView.swift
//  Baby Monitor
//

import UIKit

final class ClientSetupView: BaseView {
    
    let setupAddressButton = UIButton()
    let startDiscoveringButton = UIButton()
    lazy var addressField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Localizable.Onboarding.addressPlaceholder
        
        return textField
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [setupAddressButton, startDiscoveringButton])
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 20
        
        return stackView
    }()
    
    private lazy var searchIndicator: UIActivityIndicatorView = {
        let searchIndicator = UIActivityIndicatorView()
        searchIndicator.style = .gray
        
        return searchIndicator
    }()
    
    override init() {
        super.init()
        setup()
    }
    
    // MARK: - Public methods
    func showSearchIndicator() {
        self.searchIndicator.startAnimating()
    }
    
    func hideSearchIndicator() {
        self.searchIndicator.stopAnimating()
    }
    
    // MARK: - Private functions
    private func setup() {
        [addressField, buttonsStackView].forEach {
            addSubview($0)
        }
        addSubview(searchIndicator)
        
        setupButtons()
        setupConstraints()
    }
    
    private func setupButtons() {
        //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
        [setupAddressButton, startDiscoveringButton].forEach {
            $0.backgroundColor = .blue
        }
        
        setupAddressButton.setTitle(Localizable.Onboarding.setupAddress, for: .normal)
        startDiscoveringButton.setTitle(Localizable.Onboarding.startDiscovering, for: .normal)
    }
    
    private func setupConstraints() {
        buttonsStackView.addConstraints {
            [$0.equal(.centerX),
            $0.equal(.width, multiplier: 0.8),
            $0.equalTo(self, .bottom, .safeAreaBottom, constant: -20)]
        }
        
        [setupAddressButton, startDiscoveringButton].forEach {
            $0.addConstraints {
                [$0.equalConstant(.width, 150),
                $0.equalConstant(.height, 40)]
            }
        }
        
        addressField.addConstraints {
            [$0.equal(.centerX),
            $0.equal(.centerY),
            $0.equalConstant(.height, 50),
            $0.equalConstant(.width, 150)]
        }
        
        searchIndicator.addConstraints {
            [$0.equal(.centerX),
             $0.equal(.centerY)]
        }
    }
}
