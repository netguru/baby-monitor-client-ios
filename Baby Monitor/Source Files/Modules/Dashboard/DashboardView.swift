//
//  DashboardView.swift
//  Baby Monitor
//

import UIKit
import RxCocoa
import RxSwift

class DashboardView: BaseView {
    
    fileprivate let liveCameraButton = DashboardButtonView(role: .liveCamera)
    fileprivate let activityLogButton = DashboardButtonView(role: .activityLog)
    let babyNavigationItemView = BabyNavigationItemView(mode: .parent)
    
    let settingsBarButtonItem = UIBarButtonItem(
        image: #imageLiteral(resourceName: "settings"),
        style: .plain,
        target: nil,
        action: nil)
    private var pulseColor: UIColor = .babyMonitorBrownGray
    private lazy var backgroundPhotoImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "photo-dashboard-background"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    fileprivate let photoImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "baby-placeholder-dashboard"))
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private lazy var dashboardButtonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [liveCameraButton, activityLogButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 32
        return stackView
    }()
    private let pulsatoryView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        return view
    }()

    fileprivate let nameTextField: UITextField = {
        let textField = UITextField()
        textField.isUserInteractionEnabled = false
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(
            string: Localizable.Dashboard.yourBabyName,
            attributes: [
                .font: UIFont.customFont(withSize: .h1, weight: .medium),
                .foregroundColor: UIColor.babyMonitorPurple.withAlphaComponent(0.5)
            ])
        textField.font = UIFont.customFont(withSize: .h1, weight: .medium)
        textField.textColor = .babyMonitorPurple
        return textField
    }()
    
    private let connectionStatusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.customFont(withSize: .body, weight: .regular)
        label.text = Localizable.Dashboard.connectionStatusConnected
        return label
    }()
    
    override init() {
        super.init()
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.layer.cornerRadius = photoImageView.frame.width / 2
        babyNavigationItemView.setupPhotoImageView()
    }
    
    func updateName(_ text: String) {
        nameTextField.text = text
        babyNavigationItemView.updateBabyName(text)
    }

    func updatePhoto(_ photo: UIImage?) {
        photoImageView.image = photo
        babyNavigationItemView.updateBabyPhoto(photo ?? UIImage())
    }
    
    func firePulse() {
        AnimationFactory.shared.firePulse(onView: pulsatoryView, fromColor: pulseColor, toColor: .babyMonitorDarkGray)
    }

    // MARK: - private functions
    private func setupLayout() {
        setupBackgroundImage(UIImage())
        [backgroundPhotoImageView, photoImageView, nameTextField, connectionStatusLabel, pulsatoryView, dashboardButtonsStackView].forEach {
            addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        backgroundPhotoImageView.addConstraints {[
            $0.equalTo(self, .top, .safeAreaTop, constant: 50),
            $0.equal(.width, multiplier: 0.7),
            $0.equalTo($0, .width, .height),
            $0.equal(.centerX)
        ]
        }
        photoImageView.addConstraints {[
            $0.equal(.width, multiplier: 0.5),
            $0.equalTo($0, .width, .height),
            $0.equalTo(backgroundPhotoImageView, .centerY, .centerY),
            $0.equal(.centerX)
        ]
        }
        nameTextField.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.width, multiplier: 1),
            $0.equalTo(backgroundPhotoImageView, .top, .bottom, constant: 36)
        ]
        }
        connectionStatusLabel.addConstraints {[
            $0.equal(.centerX),
            $0.equalTo(nameTextField, .top, .bottom, constant: 7)
        ]
        }
        pulsatoryView.addConstraints {[
            $0.equalTo(connectionStatusLabel, .centerY, .centerY),
            $0.equalTo(connectionStatusLabel, .leading, .trailing, constant: 20),
            $0.equalTo(nameTextField, .top, .bottom, constant: 7)
        ]
        }
        dashboardButtonsStackView.addConstraints {[
            $0.equal(.centerX),
            $0.equalTo(self, .bottom, .safeAreaBottom, constant: -52)
        ]
        }
    }
    
    fileprivate func updateConnectionStatus(isConnected: Bool) {
        if isConnected {
            connectionStatusLabel.text = Localizable.Dashboard.connectionStatusConnected
            pulseColor = .babyMonitorLightGreen
        } else {
            connectionStatusLabel.text = Localizable.Dashboard.connectionStatusDisconnected
            pulseColor = .babyMonitorBrownGray
        }
    }
}

extension Reactive where Base: DashboardView {
    
    var settingsTap: ControlEvent<Void> {
        return base.settingsBarButtonItem.rx.tap
    }
    
    var liveCameraTap: ControlEvent<Void> {
        return base.liveCameraButton.rx.tap
    }
    
    var activityLogTap: ControlEvent<Void> {
        return base.activityLogButton.rx.tap
    }
    
    var babyName: Binder<String> {
        return Binder(base) { dashboardView, name in
            dashboardView.updateName(name)
        }
    }
    
    var babyPhoto: Binder<UIImage?> {
        return Binder(base) { dashboardView, photo in
            dashboardView.updatePhoto(photo)
        }
    }
    
    var connectionStatus: Binder<Bool> {
        return Binder(base) { dashboardView, isConnected in
            dashboardView.updateConnectionStatus(isConnected: isConnected)
        }
    }
}
