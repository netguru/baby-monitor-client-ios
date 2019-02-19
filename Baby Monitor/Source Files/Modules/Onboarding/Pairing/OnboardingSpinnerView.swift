//
//  OnboardingSpinnerView.swift
//  Baby Monitor
//

import UIKit

final class OnboardingSpinnerView: BaseOnboardingView {
    
    private let spinner = UIActivityIndicatorView()
    
    override init() {
        super.init()
        setup()
    }
    
    private func setup() {
        addSubview(spinner)
        spinner.style = .gray
        spinner.startAnimating()
        spinner.addConstraints {[
            $0.equal(.centerX)
        ]
        }
        guard let imageCenterYAnchor = imageCenterYAnchor else {
            return
        }
        spinner.centerYAnchor.constraint(equalTo: imageCenterYAnchor).isActive = true
    }
}
