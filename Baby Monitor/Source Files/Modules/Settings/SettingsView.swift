//
//  SettingsView.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import RxCocoa

final class SettingsView: UIView {

    fileprivate let editBabyPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "edit_baby_photo"), for: .normal)
        return button
    }()

    fileprivate let babyNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Your baby name"
        textField.textColor = .babyMonitorPurple
        return textField
    }()

    private let editImageView = UIImageView(image: #imageLiteral(resourceName: "edit"))

    private let underline: UIView = {
        let view = UIView()
        view.backgroundColor = .babyMonitorPurple
        return view
    }()

    private lazy var customTextInputStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [babyNameTextField, editImageView])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private let editBabyNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()

    private let rateButton = RoundedRectangleButton(title: "Rate us", backgroundColor: .babyMonitorPurple)

    private let resetButton = RoundedRectangleButton(title: "Reset the app", backgroundColor: .babyMonitorDarkPurple, borderColor: .babyMonitorNonTranslucentWhite)

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [rateButton, resetButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let signatureLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Crafted with ❤️", attributes: [.foregroundColor: UIColor.babyMonitorNonTranslucentWhite, .font: UIFont.customFont(withSize: .caption)])
        attributedText.append(NSAttributedString(string: "by Netguru", attributes: [.foregroundColor: UIColor.babyMonitorPurple, .font: UIFont.customFont(withSize: .caption)]))
        label.attributedText = attributedText
        return label
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
        backgroundColor = .babyMonitorDarkPurple
    }

    private func setupLayout() {
        editBabyNameStackView.addArrangedSubview(customTextInputStackView)
        editBabyNameStackView.addArrangedSubview(underline)
        [editBabyPhotoButton, editBabyNameStackView, buttonsStackView, signatureLabel].forEach { addSubview($0) }
        setupConstraints()
    }

    private func setupConstraints() {
        editBabyPhotoButton.addConstraints {[
            $0.equal(.top, constant: 100),
            $0.equalConstant(.width, 113),
            $0.equalConstant(.height, 113),
            $0.equal(.centerX)
        ]
        }

        underline.addConstraints {
            [$0.equalConstant(.height, 1)]
        }
        editBabyNameStackView.addConstraints {[
            $0.equalTo(editBabyPhotoButton, .top, .bottom, constant: 40),
            $0.equal(.leading, constant: 23),
            $0.equal(.trailing, constant: 23)
        ]
        }

        buttonsStackView.addConstraints {[
            $0.greaterThanOrEqualTo(editBabyNameStackView, .top, .bottom, constant: 70),
            $0.equal(.leading, constant: 23),
            $0.equal(.trailing, constant: -23)
        ]
        }

        signatureLabel.addConstraints {[
            $0.equalTo(buttonsStackView, .top, .bottom, constant: 29),
            $0.equal(.centerX)
        ]
        }
    }
}

extension Reactive where Base: SettingsView {

    var babyPhoto: Binder<UIImage?> {
        return base.editBabyPhotoButton.rx.image()
    }

    var babyName: ControlProperty<String?> {
        return base.babyNameTextField.rx.text
    }
}
