//
//  TwoOptionsBaseOnboardingView.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import RxCocoa

final class TwoOptionsBaseOnboardingView: BaseOnboardingView {
    
    fileprivate let upButton: RoundedRectangleButton = {
        let view = RoundedRectangleButton(title: "", backgroundColor: .babyMonitorPurple)
        view.titleLabel?.font = UIFont.customFont(withSize: .small, weight: .bold)
        view.titleLabel?.textColor = .white
        return view
    }()
    fileprivate let bottomButton: RoundedRectangleButton = {
        let view = RoundedRectangleButton(title: "", backgroundColor: .clear, borderColor: .white, borderWidth: 2)
        view.titleLabel?.font = UIFont.customFont(withSize: .small, weight: .bold)
        view.titleLabel?.textColor = .white
        return view
    }()
    private lazy var buttonsStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [upButton, bottomButton])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.spacing = 16
        return view
    }()
    
    override init() {
        super.init()
        setup()
    }
    
    func update(upButtonTitle title: String) {
        upButton.titleLabel?.text = title
    }
    func update(bottomButtonTitle title: String) {
        bottomButton.titleLabel?.text = title
    }
    
    private func setup() {
        addSubview(buttonsStackView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        [upButton, bottomButton].forEach { button in
            button.addConstraints {[
                $0.equalConstant(.height, 56),
            ]
            }
        }
        buttonsStackView.addConstraints {[
            $0.equal(.centerX),
            $0.equalTo(self, .bottom, .safeAreaBottom, constant: -32),
            $0.equal(.width, multiplier: 0.87)
        ]
        }
    }
}

extension Reactive where Base: TwoOptionsBaseOnboardingView {
    
    var upButtonTap: ControlEvent<Void> {
        return base.upButton.rx.tap
    }
    var bottomButtonTap: ControlEvent<Void> {
        return base.bottomButton.rx.tap
    }
}
