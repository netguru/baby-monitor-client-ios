//
//  CameraPreviewViewController.swift
//  Baby Monitor
//


import UIKit

final class CameraPreviewViewController: BaseViewController {
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [changeCameraButton, stopButton, microphoneButton])
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    private lazy var cancelItemButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                   target: self,
                                                   action: #selector(didTouchCancelButton))
    
    private let babyNavigationItemView = BabyNavigationItemView(babyName: "Franuś") //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
    private let changeCameraButton = UIButton()
    private let microphoneButton = UIButton()
    private let stopButton = UIButton()
    private let viewModel: CameraPreviewViewModel
    
    init(viewModel: CameraPreviewViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Selectors
    @objc func didTouchCancelButton() {
        viewModel.selectCancel()
    }
    
    //MARK: - Private functions
    private func setup() {
        view.backgroundColor = .gray
        navigationItem.leftBarButtonItem = cancelItemButton
        navigationItem.titleView = babyNavigationItemView
        babyNavigationItemView.onSelectArrow = { [weak self] in
            self?.viewModel.selectShowBabies()
        }
        
        view.addSubview(buttonsStackView)
        //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-65
        [changeCameraButton, stopButton, microphoneButton].forEach {
            $0.backgroundColor = .blue
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        [changeCameraButton, microphoneButton].forEach {
            $0.addConstraints {[
                $0.equalConstant(.width, 40),
                $0.equalConstant(.height, 40),
                ]}
        }
        
        stopButton.addConstraints {[
            $0.equalConstant(.width, 60),
            $0.equalConstant(.height, 60),
            ]}
        
        buttonsStackView.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.width, multiplier: 0.8),
            $0.equalTo(view, .bottom, .safeAreaBottom, constant: -20)
            ]}
    }
}
