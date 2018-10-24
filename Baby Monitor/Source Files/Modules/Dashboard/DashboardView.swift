//
//  DashboardView.swift
//  Baby Monitor
//

import UIKit
import RxCocoa
import RxSwift

class DashboardView: BaseView {
    
    private enum Constants {
        static let mainOffset: CGFloat = 20
        static let disconnectedLabelHeight: CGFloat = 40
    }
    
    fileprivate let liveCameraButton = DashboardButtonView(role: .liveCamera)
    fileprivate let talkButton = DashboardButtonView(role: .talk)
    fileprivate let playLullabyButton = DashboardButtonView(role: .playLullaby)
    let babyNavigationItemView = BabyNavigationItemView()
    let editProfileBarButtonItem = UIBarButtonItem(title: Localizable.Dashboard.editProfile,
                                                   style: .plain,
                                                   target: nil,
                                                   action: nil)
    
    fileprivate let photoButtonView = DashboardPhotoButtonView()
    
    private lazy var disconnectedLabel: UILabel = {
        let label = UILabel()
        label.text = Localizable.General.disconnected
        label.textColor = .white
        label.backgroundColor = .red
        label.textAlignment = .center
        label.alpha = 0.0
        
        return label
    }()
    private lazy var dashboardButtonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [liveCameraButton, talkButton, playLullabyButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()

    fileprivate let nameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Localizable.Dashboard.addName
        textField.textAlignment = .center
        textField.returnKeyType = .done
        return textField
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
        label.text = "Nothing unusual, Franuś is probably sleeping calmly and dreaming about sheeps and unicorns."
        return label
    }()
    
    private let layoutView = UIView() // only for centering stack view vertically
    
    private var disconnectedLabelTopOffsetConstraint: NSLayoutConstraint?
    
    override init() {
        super.init()
        setupLayout()
    }
    
    func updateName(_ text: String?) {
        nameField.text = text
        babyNavigationItemView.setBabyName(text)
    }

    func updatePhoto(_ photo: UIImage?) {
        photoButtonView.setPhoto(photo)
        babyNavigationItemView.setBabyPhoto(photo)
    }

    // MARK: - private functions
    private func setupLayout() {
        [layoutView, photoButtonView, nameField, descriptionLabel, dashboardButtonsStackView, disconnectedLabel].forEach {
            addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        layoutView.addConstraints {
            [$0.equalTo(self, .bottom, .safeAreaBottom),
             $0.equalTo(descriptionLabel, .top, .bottom),
             $0.equal(.leading),
             $0.equal(.trailing)]
        }
        
        dashboardButtonsStackView.addConstraints {
            [$0.equalTo(layoutView, .centerY, .centerY),
             $0.equal(.centerX),
             $0.equalTo(self, .width, .width, multiplier: 0.9)]
        }
        
        descriptionLabel.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.centerY),
            $0.equal(.width, multiplier: 0.9),
            $0.equalTo(nameField, .top, .bottom, constant: Constants.mainOffset)
        ]
        }
        
        nameField.addConstraints {[
            $0.equal(.centerX),
            $0.equalTo(photoButtonView, .top, .bottom, constant: Constants.mainOffset)
        ]
        }
        
        photoButtonView.addConstraints {[
            $0.equalTo(self, .top, .safeAreaTop, constant: Constants.mainOffset),
            $0.equalTo($0, .width, .height),
            $0.equal(.centerX)]
        }
        
        disconnectedLabelTopOffsetConstraint = disconnectedLabel.addConstraints {
            [$0.equalConstant(.height, Constants.disconnectedLabelHeight),
             $0.equal(.leading),
             $0.equal(.trailing),
             $0.equalTo(self, .top, .safeAreaTop, constant: -Constants.disconnectedLabelHeight)]
        }.last
    }
    
    func showIsConnected() {
        guard disconnectedLabelTopOffsetConstraint?.constant == 0.0 else {
            return
        }
        animateDisconnectLabel(alpha: 0.0, offset: -Constants.disconnectedLabelHeight)
    }
    
    func showIsDisconnected() {
        guard disconnectedLabelTopOffsetConstraint?.constant == -Constants.disconnectedLabelHeight else {
            return
        }
        animateDisconnectLabel(alpha: 1.0, offset: 0.0)
    }
    
    private func animateDisconnectLabel(alpha: CGFloat, offset: CGFloat) {
        disconnectedLabelTopOffsetConstraint?.constant = offset
        UIView.animate(withDuration: 0.2) {
            self.disconnectedLabel.alpha = alpha
            self.layoutIfNeeded()
        }
    }
}

extension Reactive where Base: DashboardView {
    var liveCameraTap: ControlEvent<Void> {
        return base.liveCameraButton.rx.tap
    }
    var talkTap: ControlEvent<Void> {
        return base.talkButton.rx.tap
    }
    var playLullabyTap: ControlEvent<Void> {
        return base.playLullabyButton.rx.tap
    }
    var switchBabyTap: ControlEvent<Void> {
        return base.babyNavigationItemView.rx.tap
    }
    var addPhotoTap: ControlEvent<Void> {
        return base.photoButtonView.rx.tap
    }
    var babyName: ControlProperty<String> {
        let name = base.nameField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(base.nameField.rx.text)
            .map { $0 ?? "" }
        let binder = Binder<String>(base.nameField) { nameField, name in
            nameField.text = name
        }
        return ControlProperty(values: name, valueSink: binder)
    }
    var babyPhoto: Binder<UIImage?> {
        return base.photoButtonView.rx.photo
    }
}
