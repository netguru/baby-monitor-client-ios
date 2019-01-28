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
    let babyNavigationItemView = BabyNavigationItemView(mode: .parent)
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
        // TODO: playLullabyButton hidden for MVP
        let stackView = UIStackView(arrangedSubviews: [liveCameraButton, talkButton])
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
        textField.font = UIFont.systemFont(ofSize: 18)
        return textField
    }()
    private let nameFieldBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "lightGray")
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
        label.text = "Your baby is laying in bed, looks likes he is sleeping soundly."
        return label
    }()
    private let tipLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
        label.text = "Take a peek without disturbing them?"
        return label
    }()
    
    private var disconnectedLabelTopOffsetConstraint: NSLayoutConstraint?
    
    override init() {
        super.init()
        setupLayout()
    }
    
    func updateName(_ text: String?) {
        nameField.text = text
        babyNavigationItemView.updateBabyName(text)
    }

    func updatePhoto(_ photo: UIImage?) {
        photoButtonView.setPhoto(photo)
    }
    
    func updatePhotoButtonLayer() {
        photoButtonView.setupPhotoButtonLayer()
    }

    // MARK: - private functions
    private func setupLayout() {
        [photoButtonView, nameField, nameFieldBorder, descriptionLabel, tipLabel, dashboardButtonsStackView, disconnectedLabel].forEach {
            addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        photoButtonView.addConstraints {[
            $0.equalTo(self, .top, .safeAreaTop),
            $0.equal(.width, multiplier: 0.9),
            $0.equalTo($0, .width, .height),
            $0.equal(.centerX)
        ]
        }
        
        nameField.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.width, multiplier: 0.6),
            $0.equalTo(photoButtonView, .top, .bottom, constant: -Constants.mainOffset)
        ]
        }
        nameFieldBorder.addConstraints {[
            $0.equalConstant(.height, 2),
            $0.equal(.centerX),
            $0.equalTo(nameField, .width, .width),
            $0.equalTo(nameField, .top, .bottom, constant: 8)
        ]
        }
        
        descriptionLabel.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.width, multiplier: 0.9),
            $0.equalTo(nameField, .top, .bottom, constant: Constants.mainOffset + 25)
        ]
        }
        
        tipLabel.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.width, multiplier: 0.9),
            $0.equalTo(dashboardButtonsStackView, .bottom, .top, constant: -25)
        ]
        }
        
        dashboardButtonsStackView.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.width, multiplier: 0.8),
            $0.equalTo(self, .bottom, .safeAreaBottom, constant: -Constants.mainOffset * 2)
        ]
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
    
    // TODO: Hidden for MVP
    // var playLullabyTap: ControlEvent<Void> {
        // return base.playLullabyButton.rx.tap
    // }
    
    var addPhotoTap: ControlEvent<Void> {
        return base.photoButtonView.rx.tap
    }
    
    var babyName: ControlProperty<String> {
        let name = base.nameField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(base.nameField.rx.text)
            .map { $0 ?? "" }
        let binder = Binder<String>(base) { dashboardView, name in
            dashboardView.updateName(name)
        }
        return ControlProperty(values: name, valueSink: binder)
    }
    
    var babyPhoto: Binder<UIImage?> {
        return Binder(base) { dashboardView, photo in
            dashboardView.updatePhoto(photo)
        }
    }
    
    var connectionStatus: Binder<Bool> {
        return Binder(base) { dashboardView, isConnection in
            isConnection ? dashboardView.showIsConnected() : dashboardView.showIsDisconnected()
        }
    }
}
