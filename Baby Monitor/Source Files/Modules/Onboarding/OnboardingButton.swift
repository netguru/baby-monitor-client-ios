//
//  OnboardingButton.swift
//  Baby Monitor
//


import UIKit

final class OnboardingButtonView: UIView {
    
    private let button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onTouchButton), for: .touchUpInside)
        return button
    }()
    
    var onSelect: (() -> Void)?
    
    init(text: String) {
        super.init(frame: .zero)
        
        button.setTitle(text, for: .normal)
        setup()
    }
    
    @available(*, unavailable, message: "Use init(text:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

