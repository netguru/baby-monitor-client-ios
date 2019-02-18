//
//  SpecifyDeviceOnboardingView.swift
//  Baby Monitor
//

import UIKit
import RxCocoa

final class SpecifyDeviceOnboardingView: OldBaseOnboardingView {
    
    lazy var parentTapEvent = parentButton.rx.tap.asObservable()
    lazy var babyTapEvent = babyButton.rx.tap.asObservable()
    
    lazy private var parentButton = OnboardingButton(title: Localizable.Onboarding.parent)
    lazy private var babyButton = OnboardingButton(title: Localizable.Onboarding.baby)
    lazy private var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [parentButton, babyButton])
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
    
    override init() {
        super.init()
        addSubview(buttonsStackView)
        updateTitle(Localizable.Onboarding.specifyDevice)
        updateDescription(Localizable.Onboarding.welcomeTo)
        [parentButton, babyButton].forEach { view in
            view.addConstraints({ [$0.equalConstant(.height, 56)] })
        }
        buttonsStackView.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.centerY, constant: -22)
        ]
        }
        buttonsStackView.leadingAnchor.constraint(equalTo: titleLeadingAnchor).isActive = true
    }
    
}
