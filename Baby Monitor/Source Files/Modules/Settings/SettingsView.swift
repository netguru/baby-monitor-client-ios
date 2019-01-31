//
//  SettingsView.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import RxCocoa

final class SettingsView: UIView {

    let cancelButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow_back"), style: .plain, target: nil, action: nil)
    
    fileprivate let editBabyPhotoButton = UIButton(type: .custom)
    fileprivate let editBabyPhotoImage = UIImageView(image: #imageLiteral(resourceName: "edit_baby_photo"))
    fileprivate let babyNameTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.attributedPlaceholder = NSAttributedString(
            string: Localizable.Settings.babyNamePlaceholder,
            attributes: [
                .font: UIFont.customFont(withSize: .h2, weight: .medium),
                .foregroundColor: UIColor.babyMonitorPurple.withAlphaComponent(0.5)
            ])
        textField.font = UIFont.customFont(withSize: .h2, weight: .medium)
        textField.textColor = .babyMonitorPurple
        return textField
    }()

    private let editImageView = UIImageView(image: #imageLiteral(resourceName: "edit"))
    private let underline: UIView = {
        let view = UIView()
        view.backgroundColor = .babyMonitorPurple
        return view
    }()

    fileprivate let rateButton = RoundedRectangleButton(title: Localizable.Settings.rateButtonTitle, backgroundColor: .babyMonitorPurple)
    fileprivate let resetButton = RoundedRectangleButton(title: Localizable.Settings.resetButtonTitle, backgroundColor: .babyMonitorDarkPurple, borderColor: .babyMonitorNonTranslucentWhite)
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [rateButton, resetButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    private let signatureImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Made with love"))
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        super.layoutSubviews()
        backgroundColor = .babyMonitorDarkPurple
        editBabyPhotoImage.layer.masksToBounds = true
        editBabyPhotoImage.layer.cornerRadius = editBabyPhotoImage.bounds.height / 2
    }

    private func setupLayout() {
        rateButton.titleLabel?.font = UIFont.customFont(withSize: .small, weight: .bold)
        resetButton.titleLabel?.font = UIFont.customFont(withSize: .small, weight: .bold)
        [editBabyPhotoImage, editBabyPhotoButton, babyNameTextField, editImageView, underline, buttonsStackView, signatureImageView].forEach { addSubview($0) }
        setupConstraints()
    }

    private func setupConstraints() {
        editImageView.addConstraints {[
            $0.equalConstant(.width, 16),
            $0.equalConstant(.height, 16)
        ]
        }
        editBabyPhotoImage.addConstraints {[
            $0.equal(.safeAreaTop, constant: 50),
            $0.equal(.centerX),
            $0.equalConstant(.width, 96),
            $0.equalConstant(.height, 96)
        ]
        }
        editImageView.addConstraints {[
            $0.equalTo(babyNameTextField, .centerY, .centerY),
            $0.equalTo(underline, .trailing, .trailing, constant: -3)
        ]
        }
        babyNameTextField.addConstraints {[
            $0.equalTo(editBabyPhotoImage, .top, .bottom, constant: 41),
            $0.equalTo(buttonsStackView, .leading, .leading),
            $0.equalTo(editImageView, .trailing, .leading, constant: -10)
            
        ]
        }
        underline.addConstraints {[
            $0.equalTo(babyNameTextField, .top, .bottom, constant: 12.5),
            $0.equalTo(babyNameTextField, .leading, .leading),
            $0.equal(.centerX),
            $0.equalConstant(.height, 1)
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
        
        buttonsStackView.addConstraints {[
            $0.equalTo(signatureImageView, .bottom, .top, constant: -29),
            $0.equal(.leading, constant: 23),
            $0.equal(.trailing, constant: -23),
            $0.equalTo(buttonsStackView, .height, .width, multiplier: 0.415)
        ]
        }

        signatureImageView.addConstraints {[
            $0.equal(.bottom, constant: -52),
            $0.equal(.centerX)
        ]
        }
    }
}

extension Reactive where Base: SettingsView {

    var babyPhoto: Binder<UIImage?> {
        return Binder<UIImage?>(base.editBabyPhotoImage) { imageView, image in
            imageView.image = image ?? #imageLiteral(resourceName: "edit_baby_photo")
        }
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
    
    var cancelButtonTap: ControlEvent<Void> {
        return base.cancelButtonItem.rx.tap
    }

    var resetButtonTap: ControlEvent<Void> {
        return base.resetButton.rx.tap
    }

    var editPhotoTap: ControlEvent<Void> {
        return base.editBabyPhotoButton.rx.tap
    }
}
