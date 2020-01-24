//
//  DisabledVideoView.swift
//  Baby Monitor
//

import UIKit

final class DisabledVideoView: BaseView {

    let tapGestureRecognizer = UITapGestureRecognizer()

    private let babyLogoView: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "childPurple"))
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(withSize: .body, weight: .light)
        label.textColor = .babyMonitorNonTranslucentWhite
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override init() {
        super.init()
        setup()
    }

    /// Updates the text in the description label.
    /// - Parameter text: The text which will be set.
    func updateDescription(with text: String) {
        descriptionLabel.text = text
    }

    private func setup() {
        [babyLogoView, descriptionLabel].forEach {
            addSubview($0)
        }
        addGestureRecognizer(tapGestureRecognizer)
        setupConstraints()
    }

    private func setupConstraints() {
        babyLogoView.addConstraints {[
            $0.equal(.centerY, constant: -150),
            $0.equal(.centerX),
            $0.equalConstant(.height, 120)
        ]
        }
        descriptionLabel.addConstraints {[
            $0.equal(.centerX),
            $0.equalTo(babyLogoView, .top, .bottom, constant: 25),
            $0.equal(.width, multiplier: 0.8)
        ]
        }
    }
}
