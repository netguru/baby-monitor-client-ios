//
//  IntroFeatureView.swift
//  Baby Monitor
//

import UIKit

class IntroFeatureView: BaseView {

    /// Performed when the user taps a left button at the bottom of the view
    var didSelectLeftAction: (() -> Void)?

    /// Performed when the user taps a right button at the bottom of the view
    var didSelectRightAction: (() -> Void)?
    var titleLabelConstraints: [NSLayoutConstraint] = []
    let leftButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.customFont(withSize: .small, weight: .medium)
        button.layer.opacity = 0.3
        return button
    }()
    let rightButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.customFont(withSize: .small, weight: .bold)
        return button
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        let fontSize: UIFont.CustomTextSize = UIDevice.screenSizeBiggerThan4Inches ? .h3 : .body
        label.font = UIFont.customFont(withSize: fontSize, weight: .bold)
        return label
    }()
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        case .recordings:
            imageView.image = #imageLiteral(resourceName: "feature baby")
            titleLabel.text = Localizable.Intro.Title.recordings
            descriptionLabel.text = Localizable.Intro.Description.recordings
        }

        [imageView, titleLabel, descriptionLabel, leftButton, rightButton].forEach {
            addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let screenHeight = UIScreen.main.bounds.height
        imageView.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.width, multiplier: 0.6),
            $0.equalTo($0, .height, .height),
            $0.equalTo(self, .top, .safeAreaTop, constant: screenHeight * 0.1)
        ]
        }
        titleLabelConstraints = titleLabel.addConstraints {[
            $0.equal(.centerX),
            $0.equalTo(imageView, .top, .bottom, constant: 42)
        ]
        }
        descriptionLabel.addConstraints {[
            $0.equal(.centerX),
            $0.equalTo(titleLabel, .top, .bottom, constant: 14)
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
