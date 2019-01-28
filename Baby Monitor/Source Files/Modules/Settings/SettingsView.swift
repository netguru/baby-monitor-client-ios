//
//  SettingsView.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import RxCocoa

final class SettingsView: UIView {

    fileprivate let editBabyPhotoButton = UIButton(type: .custom)

    fileprivate let editBabyPhotoImage = UIImageView(image: #imageLiteral(resourceName: "edit_baby_photo"))

    fileprivate let babyNameTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
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
        stackView.spacing = 12.5
        return stackView
    }()

    fileprivate let rateButton = RoundedRectangleButton(title: "Rate us", backgroundColor: .babyMonitorPurple)

    fileprivate let resetButton = RoundedRectangleButton(title: "Reset the app", backgroundColor: .babyMonitorDarkPurple, borderColor: .babyMonitorNonTranslucentWhite)

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [rateButton, resetButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
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
        editBabyPhotoImage.layer.cornerRadius = editBabyPhotoImage.bounds.height / 2
    }

    private func setupLayout() {
        editBabyNameStackView.addArrangedSubview(customTextInputStackView)
        editBabyNameStackView.addArrangedSubview(underline)
        [editBabyPhotoImage, editBabyPhotoButton, editBabyNameStackView, buttonsStackView, signatureLabel].forEach { addSubview($0) }
        setupConstraints()
    }

    private func setupConstraints() {
        editImageView.addConstraints {[
            $0.equalConstant(.width, 16),
            $0.equalConstant(.height, 16)
        ]
        }

        editBabyPhotoImage.addConstraints {[
            $0.equal(.top, constant: 100),
            $0.equal(.centerX),
            $0.equalConstant(.width, 96),
            $0.equalConstant(.height, 96)
        ]
        }

        editBabyPhotoButton.addConstraints {[
            $0.equalTo(editBabyPhotoImage, .leading, .leading),
            $0.equalTo(editBabyPhotoImage, .trailing, .trailing),
            $0.equalTo(editBabyPhotoImage, .bottom, .bottom),
            $0.equalTo(editBabyPhotoImage, .top, .top)
        ]
        }
        editBabyPhotoButton.layer.zPosition = 1
        
        underline.addConstraints {
            [$0.equalConstant(.height, 1)]
        }
        editBabyNameStackView.addConstraints {[
            $0.equalTo(editBabyPhotoButton, .top, .bottom, constant: 40),
            $0.equal(.leading, constant: 23),
            $0.equal(.trailing, constant: -23)
        ]
        }

        buttonsStackView.addConstraints {[
            $0.equalTo(signatureLabel, .bottom, .top, constant: -29),
            $0.equal(.leading, constant: 23),
            $0.equal(.trailing, constant: -23)
        ]
        }

        signatureLabel.addConstraints {[
            $0.equal(.bottom, constant: -52),
            $0.equal(.centerX)
        ]
        }
    }
}

extension Reactive where Base: SettingsView {

    var babyPhoto: Binder<UIImage?> {
        return base.editBabyPhotoImage.rx.image
    }

    var babyName: ControlProperty<String> {
        let name = base.babyNameTextField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(base.babyNameTextField.rx.text)
            .map { $0 ?? "" }
        let binder = Binder<String>(base.babyNameTextField) { textField, name in
            textField.text = name
        }
        return ControlProperty(values: name, valueSink: binder)
    }

    var rateButtonTap: ControlEvent<Void> {
        return base.rateButton.rx.tap
    }

    var resetButtonTap: ControlEvent<Void> {
        return base.resetButton.rx.tap
    }

    var editPhotoTap: ControlEvent<Void> {
        return base.editBabyPhotoButton.rx.tap
    }
}
