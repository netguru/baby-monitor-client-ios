//
//  OnboardingSpinnerView.swift
//  Baby Monitor
//

import UIKit

final class OnboardingSpinnerView: ImageOnboardingView {
    
    private let spinner = UIActivityIndicatorView()
    
    override init(role: Role) {
        super.init(role: role)
        setup()
    }
    
    private func setup() {
        hideNextButton()
        addSubview(spinner)
        spinner.style = .gray
        spinner.startAnimating()
        spinner.addConstraints {[
            $0.equal(.centerX)
        ]
        }
        spinner.centerYAnchor.constraint(equalTo: imageCenterYAnchor).isActive = true
    }
}
