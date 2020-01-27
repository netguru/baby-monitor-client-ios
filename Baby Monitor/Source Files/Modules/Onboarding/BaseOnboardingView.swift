//
//  BaseOnboardingView.swift
//  Baby Monitor
//

import UIKit

class BaseOnboardingView: BaseView {
    
    var imageViewTopConstraint: NSLayoutConstraint?
    var imageCenterYAnchor: NSLayoutYAxisAnchor?
    var descriptionBottomAnchor: NSLayoutYAxisAnchor?
    let imageView = UIImageView()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.customFont(withSize: .body, weight: .bold)
        view.textColor = .babyMonitorPurple
        view.numberOfLines = 0
        return view
    }()
    private let mainDescriptionLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.customFont(withSize: Constants.responsive(ofSizes: [.small: .h2, .medium: .h1]), weight: .medium)
        view.numberOfLines = 0
        view.textColor = .white
        return view
    }()
    private let secondaryDescriptionLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.customFont(withSize: Constants.responsive(ofSizes: [.small: .small, .medium: .body]), weight: .regular)
        view.numberOfLines = 0
        view.textColor = .babyMonitorPurple
        return view
    }()
    private lazy var descriptionsStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [mainDescriptionLabel, secondaryDescriptionLabel])
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fillProportionally
        view.spacing = 13
        return view
    }()
    
    override init() {
        super.init()
        setup()
    }
    
    func update(title: String) {
        titleLabel.text = title
    }
    func update(mainDescription: String) {
        mainDescriptionLabel.text = mainDescription
    }
    func update(secondaryDescription: NSAttributedString?) {
        secondaryDescriptionLabel.attributedText = secondaryDescription
    }
    func update(image: UIImage) {
        imageView.image = image
    }
    
    private func setup() {
        [titleLabel, descriptionsStackView, imageView].forEach {
            addSubview($0)
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        let screenHeight = UIScreen.main.bounds.height
        titleLabel.addConstraints {[
            $0.equal(.leading, constant: 24),
            $0.equalTo(self, .top, .safeAreaTop, constant: Constants.responsive(ofSizes: [.small: screenHeight * 0.02, .medium: screenHeight * 0.1])),
            $0.equal(.centerX)
        ]
        }
        descriptionsStackView.addConstraints {[
            $0.equalTo(titleLabel, .leading, .leading),
            $0.equal(.trailing),
            $0.equalTo(titleLabel, .top, .bottom, constant: 8)
        ]
        }
        imageViewTopConstraint = imageView.addConstraints {[
            $0.equalTo(descriptionsStackView, .top, .bottom, constant: 28),
            $0.equal(.centerX)
        ]
        }.first
        imageCenterYAnchor = imageView.centerYAnchor
        descriptionBottomAnchor = descriptionsStackView.bottomAnchor
    }
}
