//
//  SpecifyDeviceOnboardingView.swift
//  Baby Monitor
//

import UIKit
import RxCocoa
import RxSwift

final class SpecifyDeviceOnboardingView: BaseView {

    lazy var parentTapEvent = parentButton.rx.tap.asObservable()
    lazy var babyTapEvent = babyButton.rx.tap.asObservable()
    
    let cancelItemButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowBack"),
                                           style: .plain,
                                           target: nil,
                                           action: nil)
    
    private let parentButton = DescriptiveRoundedRectangleButton(title: Localizable.Onboarding.parent,
                                                                 description: Localizable.Onboarding.SpecifyDevice.Info.specifyParentButton,
                                                                 image: #imageLiteral(resourceName: "camera-icon"))
    
    private let babyButton = DescriptiveRoundedRectangleButton(title: Localizable.Onboarding.baby,
                                                               description: Localizable.Onboarding.SpecifyDevice.Info.specifyBabyButton,
                                                               image: #imageLiteral(resourceName: "baby-icon"))
    
    private let specifyDeviceImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "specify-device-checkmark"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let defineDeviceLabel: UILabel = {
        let label = UILabel()
        label.text = Localizable.Onboarding.defineDevice
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 2
        label.font = UIFont.customFont(withSize: .h2, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = Localizable.Onboarding.defineDescription
        label.textAlignment = .center
        label.textColor = .babyMonitorPurple
        label.numberOfLines = 1
        label.font = UIFont.customFont(withSize: .body, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [parentButton, babyButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 18
        return stackView
    }()
    
    override init() {
        super.init()
        [specifyDeviceImageView, defineDeviceLabel, instructionLabel, buttonsStackView].forEach(addSubview)
        setupConstraints()
    }
    
    private func setupConstraints() {
        let topImageConstraintConstant: CGFloat = UIDevice.screenSizeBiggerThan4Inches ? 50 : 5
        
        NSLayoutConstraint.activate([
            specifyDeviceImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: topImageConstraintConstant),
            specifyDeviceImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            defineDeviceLabel.topAnchor.constraint(equalTo: specifyDeviceImageView.bottomAnchor, constant: 36),
            defineDeviceLabel.widthAnchor.constraint(equalToConstant: 180),
            defineDeviceLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            instructionLabel.topAnchor.constraint(equalTo: defineDeviceLabel.bottomAnchor, constant: 16),
            instructionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonsStackView.topAnchor.constraint(greaterThanOrEqualTo: instructionLabel.bottomAnchor, constant: 20),
            buttonsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            buttonsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24)
        ])
    }
}

extension Reactive where Base: SpecifyDeviceOnboardingView {
    
    var cancelTap: ControlEvent<Void> {
        return base.cancelItemButton.rx.tap
    }
}
