//
//  OnboardingSpinnerView.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingSpinnerView: BaseOnboardingView {

    private let spinner = UIActivityIndicatorView()
    let cancelButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowBack"),
                                           style: .plain,
                                           target: nil,
                                           action: nil)

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

extension Reactive where Base: OnboardingSpinnerView {

    var cancelTap: ControlEvent<Void> {
        return base.cancelButtonItem.rx.tap
    }
}
