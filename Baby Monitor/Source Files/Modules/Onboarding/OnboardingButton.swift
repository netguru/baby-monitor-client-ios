//
//  OnboardingButton.swift
//  Baby Monitor
//

import UIKit

final class OnboardingButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        setup(title: title)
    }
    
    @available(*, unavailable, message: "Use init(title:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2.0
    }
    
    private func setup(title: String) {
        backgroundColor = .babyMonitorPurple
        titleLabel?.font = UIFont.avertaBold.withSize(14)
        setTitle(title, for: .normal)
    }
}
