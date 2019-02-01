//
//  IntroFeatureView.swift
//  Baby Monitor
//

import UIKit

final class IntroFeatureView: BaseView {

    /// Performed when the user taps a left button at the bottom of the view
    var didSelectLeftAction: (() -> Void)?

    /// Performed when the user taps a right button at the bottom of the view
    var didSelectRightAction: (() -> Void)?

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
        let fontSize: UIFont.CustomTextSize = UIDevice.screenSizeBiggerThan4Inches ? .small : .caption
        label.font = UIFont.customFont(withSize: fontSize, weight: .regular)
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
        let spacing: CGFloat = UIDevice.screenSizeBiggerThan4Inches ? 15 : 5
        introStackView.setCustomSpacing(spacing, after: titleLabel)
        let lowPriority = UILayoutPriority(999)
        let widthMultiplier: CGFloat = UIDevice.screenSizeBiggerThan4Point7Inches ? 0.7 : 0.8
        let widthMultiplyContraint = introStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: widthMultiplier)
        let heightMultiplyContraint = introStackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6)
        widthMultiplyContraint.priority = lowPriority
        heightMultiplyContraint.priority = lowPriority

        NSLayoutConstraint.activate([
            introStackView.widthAnchor.constraint(lessThanOrEqualToConstant: 400),
            widthMultiplyContraint,
            introStackView.heightAnchor.constraint(lessThanOrEqualToConstant: 600),
            heightMultiplyContraint
        ])

        introStackView.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.centerY, constant: -50)
        ]
        }
        imageView.addConstraints {[
            $0.equalTo(introStackView, .width, .width, multiplier: 0.8)
        ]
        }
        let sideConstantForButtons: CGFloat = 35
        leftButton.addConstraints {[
            $0.equalTo(self, .leading, .leading, constant: sideConstantForButtons),
            $0.equalTo(self, .bottom, .bottom, constant: -44)
        ]
        }
        rightButton.addConstraints {[
            $0.equalTo(self, .trailing, .trailing, constant: -sideConstantForButtons),
            $0.equalTo(leftButton, .centerY, .centerY)
        ]
        }
    }
}
