//
//  DashboardViewController.swift
//  Baby Monitor
//


import UIKit

final class DashboardViewController: BaseViewController {
    
    private enum Constants {
        static let mainOffset: CGFloat = 20
    }
    
    private let photoImageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dashboardButtonsStackView = UIStackView()
    private let layoutView = UIView() // only for centering stack view vertically
    private let liveCameraButton = DashboardButtonView(image: UIImage(), text: Localizable.Dashboard.liveCamera)
    private let talkButton = DashboardButtonView(image: UIImage(), text: Localizable.Dashboard.talk)
    private let playLullabyButton = DashboardButtonView(image: UIImage(), text: Localizable.Dashboard.playLullaby)
    private let editProfileBarButtonItem = UIBarButtonItem(title: Localizable.Dashboard.editProfile,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(onTouchEditProfileButton))
    
    private let viewModel: DashboardViewViewModel
    
    init(viewModel: DashboardViewViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editProfileBarButtonItem
        title = Localizable.TabBar.dashboard
        navigationItem.title = ""
        setupLayout()
    }
    
    //MARK: - Selectors
    @objc private func onTouchEditProfileButton() {
        //TODO: add implementation
    }
    
    //MARK: - private functions
    private func setupLayout() {
        view.addSubview(layoutView)
        setupPhotoImageView()
        setupLabels()
        setupDashboardButtonsStackView()
        
        setupConstraints()
    }
    
    private func setupPhotoImageView() {
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.backgroundColor = .red
        view.addSubview(photoImageView)
    }
    
    private func setupLabels() {
        //TODO: mock for now
        nameLabel.text = "Franuś"
        view.addSubview(nameLabel)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        //TODO: mock for now
        descriptionLabel.text = "Nothing unusual, Franuś is probably sleeping calmly and dreaming about sheeps and unicorns."
        view.addSubview(descriptionLabel)
    }
    
    private func setupDashboardButtonsStackView() {
        dashboardButtonsStackView.axis = .horizontal
        dashboardButtonsStackView.distribution = .fillEqually
        dashboardButtonsStackView.alignment = .center
        [liveCameraButton, talkButton, playLullabyButton].forEach {
            dashboardButtonsStackView.addArrangedSubview($0)
        }
        view.addSubview(dashboardButtonsStackView)
    }
    
    private func setupConstraints() {
        layoutView.addConstraints {[
            $0.equalTo(view, .bottom, .safeAreaBottom),
            $0.equalTo(descriptionLabel, .top, .bottom),
            $0.equal(.leading),
            $0.equal(.trailing)
        ]}
        
        dashboardButtonsStackView.addConstraints {[
            $0.equalTo(layoutView, .centerY, .centerY),
            $0.equal(.centerX),
            $0.equalTo(view, .width, .width, multiplier: 0.9),
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
            $0.equalTo(view, .top, .safeAreaTop, constant: Constants.mainOffset),
            $0.equalTo($0, .width, .height),
            $0.equal(.centerX)
        ]}
    }
}
