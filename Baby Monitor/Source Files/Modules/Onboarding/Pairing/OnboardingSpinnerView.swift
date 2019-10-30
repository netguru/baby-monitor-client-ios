//
//  OnboardingSpinnerView.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingSpinnerView: BaseOnboardingView {

    private let spinner = UIActivityIndicatorView()
    fileprivate let cancelButton = RoundedRectangleButton(title: Localizable.General.cancel,
                                                          backgroundColor: .clear,
                                                          borderColor: .babyMonitorPurple,
                                                          borderWidth: 2.0)

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
        addCancelButton()
    }

    private func addCancelButton() {
        addSubview(cancelButton)
        cancelButton.addConstraints {[
            $0.equalTo(self, .bottom, .safeAreaBottom, constant: -32),
            $0.equalConstant(.height, 56),
            $0.equal(.centerX),
            $0.equal(.leading, constant: 24)
        ]
        }
    }
}

extension Reactive where Base: OnboardingSpinnerView {

    var cancelTap: ControlEvent<Void> {
        return base.cancelButton.rx.tap
    }
}
