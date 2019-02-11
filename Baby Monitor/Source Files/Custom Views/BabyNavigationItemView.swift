//
//  BabyNavigationItemView.swift
//  Baby Monitor
//

import UIKit
import RxCocoa
import RxSwift

final class BabyNavigationItemView: UIView {

    fileprivate let nameTextField: UITextField = {
        let textField = UITextField()
        textField.isUserInteractionEnabled = false
        textField.attributedPlaceholder = NSAttributedString(
            string: Localizable.Settings.babyNamePlaceholder,
            attributes: [
                .font: UIFont.customFont(withSize: .body, weight: .medium),
                .foregroundColor: UIColor.white
            ])
        textField.font = UIFont.customFont(withSize: .body, weight: .medium)
        textField.textColor = .white
        return textField
    }()
    
    private lazy var photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = #imageLiteral(resourceName: "baby logo welcome screen")
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()

    fileprivate let pulsatoryView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return view
    }()

    init(mode: AppMode) {
        super.init(frame: .zero)
        setup(mode: mode)
    }

    @available(*, unavailable, message: "Use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPhotoImageView() {
        photoImageView.layer.cornerRadius = photoImageView.frame.height / 2
    }

    func updateBabyName(_ name: String) {
        nameTextField.text = name
    }
    
    func updateBabyPhoto(_ photo: UIImage) {
        photoImageView.image = photo
    }
    
    func firePulse() {
        AnimationFactory.shared.firePulse(onView: pulsatoryView, fromColor: UIColor.babyMonitorLightGreen, toColor: UIColor(named: "darkPurple") ?? .purple)
    }
    
    // MARK: - View setup
    private func setup(mode: AppMode) {
        backgroundColor = .clear
        addSubview(stackView)
        stackView.addConstraints {
            $0.equalEdges()
        }
        switch mode {
        case .baby:
            [nameTextField, pulsatoryView].forEach {
                stackView.addArrangedSubview($0)
            }
            pulsatoryView.addConstraints {[
                $0.equalTo(stackView, .height, .height, multiplier: 0.5),
                $0.equalTo(pulsatoryView, .width, .height)
            ]
            }
        case .parent:
            [photoImageView, nameTextField].forEach {
                stackView.addArrangedSubview($0)
            }
            photoImageView.addConstraints {[
                $0.equalTo(self, .height, .height, multiplier: 0.6),
                $0.equalTo(photoImageView, .width, .height)
            ]
            }
        case .none:
            break
        }
    }
}

extension Reactive where Base: BabyNavigationItemView {
    
    var babyName: Binder<String> {
        return Binder(base.nameTextField, binding: { nameLabel, name in
            nameLabel.text = name
        })
    }
}
