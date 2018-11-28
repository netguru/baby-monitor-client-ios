//
//  IntroFeatureView.swift
//  Baby Monitor
//

import UIKit

final class IntroFeatureView: BaseView {
    
    var didSelectNextAction: (() -> Void)?
    
    private enum Constants {
        static let buttonHeight: CGFloat = 50
        static let mainOffset: CGFloat = 20
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
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(Constants.textAlpha)
        label.font = .systemFont(ofSize: 14)
        label.layer.opacity = 0.5
        // TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
        label.text = "Your baby is laying in bed, looks likes he is sleeping soundly."
        return label
    }()
    private let nextButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    private lazy var introStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    init(role: IntroFeature) {
        super.init()
        setup(role: role)
    }
    
    // MARK: - Selectors
    @objc private func didTapNextButton() {
        didSelectNextAction?()
    }
    
    private func setup(role: IntroFeature) {
        switch role {
        case .featureA:
            imageView.image = #imageLiteral(resourceName: "feature-a")
            nextButton.setTitle(Localizable.General.next, for: .normal)
            titleLabel.text = Localizable.Intro.featureDetect
        case .featureB:
            imageView.image = #imageLiteral(resourceName: "feature-c")
            titleLabel.text = Localizable.Intro.featureMonitor
            nextButton.setTitle(Localizable.Intro.setupBabyMonitor, for: .normal)
            nextButton.layer.borderColor = UIColor.clear.cgColor
            nextButton.backgroundColor = UIColor(named: "darkPurple")
        }
        
        [introStackView, nextButton].forEach {
            addSubview($0)
        }

        [nextButton].forEach {
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.layer.cornerRadius = Constants.buttonHeight / 2
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        introStackView.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.width, multiplier: 0.8),
            $0.equalTo(self, .top, .safeAreaTop, constant: Constants.mainOffset * 2)
        ]
        }
        
        [titleLabel, descriptionLabel].forEach {
            $0.addConstraints {[
                $0.equal(.width, multiplier: 0.8)
            ]
            }
        }
        
        nextButton.addConstraints {[
            $0.equal(.centerX),
            $0.equalConstant(.height, Constants.buttonHeight),
            $0.equal(.width, multiplier: 0.9),
            $0.equalTo(self, .bottom, .safeAreaBottom, constant: -Constants.mainOffset)
        ]
        }
    }
}
