//
//  DashboardView.swift
//  Baby Monitor
//


import UIKit

class DashboardView: BaseView {
    
    private enum Constants {
        static let mainOffset: CGFloat = 20
    }
    
    let liveCameraButton = DashboardButtonView(image: UIImage(), text: Localizable.Dashboard.liveCamera)
    let talkButton = DashboardButtonView(image: UIImage(), text: Localizable.Dashboard.talk)
    let playLullabyButton = DashboardButtonView(image: UIImage(), text: Localizable.Dashboard.playLullaby)
    let babyNavigationItemView = BabyNavigationItemView()
    let editProfileBarButtonItem = UIBarButtonItem(title: Localizable.Dashboard.editProfile, style: .plain, target: nil, action: nil)
    let photoButtonView = DashboardPhotoButtonView()
    
    private lazy var dashboardButtonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [liveCameraButton, talkButton, playLullabyButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    let nameField: UITextField = {
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
    
    override init() {
        super.init()
        setupLayout()
    }
    
    //MARK: - private functions
    private func setupLayout() {
        [layoutView, photoButtonView, nameField, descriptionLabel, dashboardButtonsStackView].forEach {
            addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        layoutView.addConstraints {[
            $0.equalTo(self, .bottom, .safeAreaBottom),
            $0.equalTo(descriptionLabel, .top, .bottom),
            $0.equal(.leading),
            $0.equal(.trailing)
        ]}
        
        dashboardButtonsStackView.addConstraints {[
            $0.equalTo(layoutView, .centerY, .centerY),
            $0.equal(.centerX),
            $0.equalTo(self, .width, .width, multiplier: 0.9),
        ]}
        
        descriptionLabel.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.centerY),
            $0.equal(.width, multiplier: 0.9),
            $0.equalTo(nameField, .top, .bottom, constant: Constants.mainOffset)
        ]}
        
        nameField.addConstraints {[
            $0.equal(.centerX),
            $0.equalTo(photoButtonView, .top, .bottom, constant: Constants.mainOffset)
        ]}
        
        photoButtonView.addConstraints {[
            $0.equalTo(self, .top, .safeAreaTop, constant: Constants.mainOffset),
            $0.equalTo($0, .width, .height),
            $0.equal(.centerX)
        ]}
    }
}
