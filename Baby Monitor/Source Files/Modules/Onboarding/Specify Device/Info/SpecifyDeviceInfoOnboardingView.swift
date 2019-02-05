//
//  SpecifyDeviceInfoOnboardingView.swift
//  Baby Monitor
//

import Foundation
import RxCocoa

final class SpecifyDeviceInfoOnboardingView: BaseView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "sync.png")
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        let fontSize: UIFont.CustomTextSize = UIDevice.screenSizeBiggerThan4Inches ? .h2 : .h3
        label.font = UIFont.customFont(withSize: fontSize, weight: .bold)
        label.text = Localizable.Onboarding.SpecifyDevice.Info.title
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.babyMonitorPurple
        let fontSize: UIFont.CustomTextSize = UIDevice.screenSizeBiggerThan4Inches ? .body : .small
        label.font = UIFont.customFont(withSize: fontSize, weight: .regular)
        label.text = Localizable.Onboarding.SpecifyDevice.Info.description
        return label
    }()

    private let stepLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.white
        let fontSize: UIFont.CustomTextSize = UIDevice.screenSizeBiggerThan4Inches ? .small : .caption
        label.font = UIFont.customFont(withSize: fontSize, weight: .regular)
        label.text = Localizable.Onboarding.SpecifyDevice.Info.stepDescription
        return label
    }()

    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "arrow down.png")
        return imageView
    }()

    private let specifyButton: UIButton = {
        let button = RoundedRectangleButton(title: Localizable.Onboarding.SpecifyDevice.Info.specifyButton,
                                            borderColor: .white)
//        button.addTarget(self, action: #selector(didTapSpecifyButton), for: .touchUpInside)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.customFont(withSize: .small, weight: .bold)
        return button
    }()

    override init() {
        super.init()
        [imageView, titleLabel, descriptionLabel, stepLabel, arrowImageView, specifyButton].forEach {
            addSubview($0)
        }
        setupConstraints()
    }

    private func setupConstraints() {
        let topImageConstraintConstant: CGFloat = UIDevice.screenSizeBiggerThan4Inches ? 100 : 50
        imageView.addConstraints {[
            $0.equal(.centerX),
            $0.equalTo(self, .top, .top, constant: topImageConstraintConstant),
            $0.equalConstant(.height, 115)
        ]
        }
        titleLabel.addConstraints {[
            $0.equal(.centerX),
            $0.equalTo(imageView, .top, .bottom, constant: 33)
        ]
        }
        descriptionLabel.addConstraints {[
            $0.equal(.centerX),
            $0.equalTo(titleLabel, .top, .bottom, constant: 16)
        ]
        }
        stepLabel.addConstraints {[
            $0.equal(.centerX),
            $0.equalTo(descriptionLabel, .top, .bottom, constant: 31)
        ]
        }
        arrowImageView.addConstraints {[
            $0.equal(.centerX),
            $0.equalTo(stepLabel, .top, .bottom, constant: 31)
        ]
        }
        specifyButton.addConstraints {[
            $0.equal(.centerX),
            $0.equalTo(self, .bottom, .bottom, constant: -50),
            $0.equal(.leading, constant: 23)
        ]
        }
    }

}
