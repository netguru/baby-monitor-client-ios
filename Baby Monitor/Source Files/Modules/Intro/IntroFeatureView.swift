//
//  IntroFeatureView.swift
//  Baby Monitor
//

import UIKit

final class IntroFeatureView: BaseView {
    
    var didSelectRightAction: (() -> Void)?

    var didSelectLeftAction: (() -> Void)?

    private enum Constants {
        static let buttonHeight: CGFloat = 50
        static let textAlpha: CGFloat = 0.7
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        let fontSize: UIFont.CustomTextSize = UIDevice.screenSizeBiggerThan4Inches ? .h3 : .body
        label.font = UIFont.customFont(withSize: fontSize, weight: .bold)
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.babyMonitorPurple
        let fontSize: UIFont.CustomTextSize = UIDevice.screenSizeBiggerThan4Inches ? .body : .small
        label.font = UIFont.customFont(withSize: fontSize, weight: .regular)
        label.text = "Easily check on your baby whenever and wherever you are"
        return label
    }()
    private let leftButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.customFont(withSize: .small, weight: .medium)
        button.layer.opacity = 0.3
        return button
    }()
    private let rightButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.customFont(withSize: .small, weight: .bold)
        return button
    }()
    private lazy var introStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    init(role: IntroFeature) {
        super.init()
        setup(role: role)
    }
    
    // MARK: - Selectors
    @objc private func didTapLeftButton() {
        didSelectLeftAction?()
    }

    @objc private func didTapRightButton() {
        didSelectRightAction?()
    }

    private func setup(role: IntroFeature) {
        leftButton.setTitle(Localizable.Intro.Buttons.skip, for: .normal)
        rightButton.setTitle(Localizable.Intro.Buttons.next, for: .normal)
        switch role {
        case .monitoring:
            imageView.image = #imageLiteral(resourceName: "feature camera.png")
            titleLabel.text = Localizable.Intro.Title.monitoring
            descriptionLabel.text = Localizable.Intro.Description.monitoring
        case .detection:
            imageView.image = #imageLiteral(resourceName: "feature baby.png")
            titleLabel.text = Localizable.Intro.Title.detection
            descriptionLabel.text = Localizable.Intro.Description.detection
        case .safety:
            imageView.image = #imageLiteral(resourceName: "safety.png")
            titleLabel.text = Localizable.Intro.Title.safety
            descriptionLabel.text = Localizable.Intro.Description.safety
        }

        [introStackView, leftButton, rightButton].forEach {
            addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        introStackView.setCustomSpacing(15, after: titleLabel)
        introStackView.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.centerY, constant: -50),
            $0.equal(.width, multiplier: 0.7),
            $0.equal(.height, multiplier: 0.6)
        ]
        }
        imageView.addConstraints {[
            $0.equalTo(introStackView, .width, .width, multiplier: 0.8)
        ]
        }
        leftButton.addConstraints {[
            $0.equalTo(self, .leading, .leading, constant: 24),
            $0.equalTo(self, .bottom, .safeAreaBottom, constant: -44)
        ]
        }
        rightButton.addConstraints {[
            $0.equalTo(self, .trailing, .trailing, constant: -24),
            $0.equalTo(leftButton, .centerY, .centerY)
        ]
        }
    }
}
