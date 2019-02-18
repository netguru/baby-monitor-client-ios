//
//  BaseSettingsView.swift
//  Baby Monitor
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class BaseSettingsView: UIView {
    
    let cancelButtonItem = UIBarButtonItem(
        image: #imageLiteral(resourceName: "arrow_back"),
        style: .plain,
        target: nil,
        action: nil
    )
    
    fileprivate let rateButton = RoundedRectangleButton(title: Localizable.Settings.rateButtonTitle, backgroundColor: .babyMonitorPurple)
    fileprivate let resetButton = RoundedRectangleButton(title: Localizable.Settings.resetButtonTitle, backgroundColor: .babyMonitorDarkPurple, borderColor: .babyMonitorNonTranslucentWhite)
    private(set) lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [rateButton, resetButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    private let signatureImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Made with love"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    @available(*, unavailable, message: "Use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Initializes settings view
    init() {
        super.init(frame: UIScreen.main.bounds)
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .babyMonitorDarkPurple
    }
    
    private func setupLayout() {
        rateButton.titleLabel?.font = UIFont.customFont(withSize: .small, weight: .bold)
        resetButton.titleLabel?.font = UIFont.customFont(withSize: .small, weight: .bold)
        [ buttonsStackView, signatureImageView].forEach { addSubview($0) }
        setupConstraints()
    }
    
    private func setupConstraints() {
        buttonsStackView.addConstraints {[
            $0.equalTo(signatureImageView, .bottom, .top, constant: -29),
            $0.equal(.leading, constant: 23),
            $0.equal(.trailing, constant: -23),
            $0.equalTo(buttonsStackView, .height, .width, multiplier: 0.415)
        ]
        }
        signatureImageView.addConstraints {[
            $0.equal(.bottom, constant: -52),
            $0.equal(.centerX)
        ]
        }
    }
}

extension Reactive where Base: BaseSettingsView {
    
    var rateButtonTap: ControlEvent<Void> {
        return base.rateButton.rx.tap
    }
    
    var cancelButtonTap: ControlEvent<Void> {
        return base.cancelButtonItem.rx.tap
    }
    
    var resetButtonTap: ControlEvent<Void> {
        return base.resetButton.rx.tap
    }
}
