//
//  DashboardView.swift
//  Baby Monitor
//


import UIKit

class DashboardView: BaseView {
    
    private enum Constants {
        static let mainOffset: CGFloat = 20
    }
    
    let babyNavigationItemView = BabyNavigationItemView(babyName: "Franuś") //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
    let editProfileBarButtonItem = UIBarButtonItem(title: Localizable.Dashboard.editProfile,
                                                   style: .plain,
                                                   target: nil,
                                                   action: nil)
    
    private lazy var dashboardButtonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [liveCameraButton, talkButton, playLullabyButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        //TODO: remove color once assets are available, ticket: https://netguru.atlassian.net/browse/BM-65
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
        label.text = "Franuś"
        return label
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
    private let liveCameraButton = DashboardButtonView(image: UIImage(), text: Localizable.Dashboard.liveCamera)
    private let talkButton = DashboardButtonView(image: UIImage(), text: Localizable.Dashboard.talk)
    private let playLullabyButton = DashboardButtonView(image: UIImage(), text: Localizable.Dashboard.playLullaby)
    
    override init() {
        super.init()
        setupLayout()
    }
    
    //MARK: - private functions
    private func setupLayout() {
        [layoutView, photoImageView, nameLabel, descriptionLabel, dashboardButtonsStackView].forEach {
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
            $0.equalTo(nameLabel, .top, .bottom, constant: Constants.mainOffset)
        ]}
        
        nameLabel.addConstraints {[
            $0.equal(.centerX),
            $0.equalTo(photoImageView, .top, .bottom, constant: Constants.mainOffset)
        ]}
        
        photoImageView.addConstraints {[
            $0.equalTo(self, .top, .safeAreaTop, constant: Constants.mainOffset),
            $0.equalTo($0, .width, .height),
            $0.equal(.centerX)
        ]}
    }
}
