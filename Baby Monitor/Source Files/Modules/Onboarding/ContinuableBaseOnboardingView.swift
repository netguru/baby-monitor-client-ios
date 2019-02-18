//
//  ContinuableBaseOnboardingView.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import RxCocoa

final class ContinuableBaseOnboardingView: BaseOnboardingView {
    
    let cancelButtonItem = UIBarButtonItem(
        image: #imageLiteral(resourceName: "arrow_back"),
        style: .plain,
        target: nil,
        action: nil
    )
    
    fileprivate let button = RoundedRectangleButton(title: "", backgroundColor: .babyMonitorPurple)
    
    override init() {
        super.init()
        setup()
    }
    
    func update(buttonTitle: String) {
        button.setTitle(buttonTitle, for: .normal)
    }
    
    private func setup() {
        addSubview(button)
        button.titleLabel?.font = UIFont.customFont(withSize: .small, weight: .bold)
        setupConstraints()
    }
    
    private func setupConstraints() {
        button.addConstraints {[
            $0.equalTo(self, .bottom, .safeAreaBottom, constant: -32),
            $0.equalConstant(.height, 56),
            $0.equal(.centerX),
            $0.equal(.leading, constant: 24)
        ]
        }
    }
}

extension Reactive where Base: ContinuableBaseOnboardingView {
    
    var buttonTap: ControlEvent<Void> {
        return base.button.rx.tap
    }
    var cancelButtonTap: ControlEvent<Void> {
        return base.cancelButtonItem.rx.tap
    }
}
