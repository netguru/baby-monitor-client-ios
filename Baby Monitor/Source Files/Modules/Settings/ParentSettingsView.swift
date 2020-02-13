//
//  ParentSettingsView.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import RxCocoa

final class ParentSettingsView: BaseSettingsView {
    
    fileprivate let editBabyPhotoButton = UIButton(type: .custom)

    fileprivate let editBabyPhotoImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "edit_baby_photo"))
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
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

    fileprivate lazy var voiceDetectionModeControl: UISegmentedControl  = {
        let segmentedControl = UISegmentedControl(items: voiceDetectionTitles)
        segmentedControl.tintColor = .white
        segmentedControl.selectedSegmentIndex = selectedVoiceModeIndex
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.customFont(withSize: .body),
            .foregroundColor: UIColor.babyMonitorPurple
        ]
        segmentedControl.setTitleTextAttributes(attributes, for: .normal)
        return segmentedControl
    }()

    private let voiceDetectionTitles: [String]
    private let selectedVoiceModeIndex: Int

    private let editImageView = UIImageView(image: #imageLiteral(resourceName: "edit"))
    
    private let underline: UIView = {
        let view = UIView()
        view.backgroundColor = .babyMonitorPurple
        return view
    }()

    /// Initializes settings view
    init(appVersion: String, voiceDetectionTitles: [String], selectedVoiceModeIndex: Int) {
        self.voiceDetectionTitles = voiceDetectionTitles
        self.selectedVoiceModeIndex = selectedVoiceModeIndex
        super.init(appVersion: appVersion)
        setupLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .babyMonitorDarkPurple
        editBabyPhotoImage.layer.cornerRadius = editBabyPhotoImage.bounds.height / 2
    }

    private func setupLayout() {
        [editBabyPhotoImage,
         editBabyPhotoButton,
         babyNameTextField,
         editImageView,
         underline,
         voiceDetectionModeControl].forEach { addSubview($0) }
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
        voiceDetectionModeControl.addConstraints {[
            $0.equalTo(underline, .top, .bottom, constant: 30),
            $0.equalTo(underline, .width, .width),
            $0.equal(.centerX)
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
    }
}

extension Reactive where Base: ParentSettingsView {

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

    var voiceModeTap: ControlProperty<Int> {
        return base.voiceDetectionModeControl.rx.selectedSegmentIndex
    }

    var editPhotoTap: Observable<UIButton> {
        return base.editBabyPhotoButton.rx.tap.map { [unowned base] in base.editBabyPhotoButton }
    }
}
