//
//  OnboardingButton.swift
//  Baby Monitor
//


import UIKit

final class OnboardingButtonView: BaseView {
    
    private let button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onTouchButton), for: .touchUpInside)
        return button
    }()
    
    var onSelect: (() -> Void)?
    
    init(text: String) {
        super.init()
        
        button.setTitle(text, for: .normal)
        setup()
    }
    
    //MARK: - Selectors
    @objc private func onTouchButton() {
        onSelect?()
    }
    
    //MARK: - private functions
    private func setup() {
        addSubview(button)
        button.backgroundColor = .blue
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        button.addConstraints {
            $0.equalEdges()
        }
        
        button.addConstraints {[
            $0.equalConstant(.width, 150),
            $0.equalConstant(.height, 40),
        ]}
    }
}

