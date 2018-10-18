//
//  CameraPreviewView.swift
//  Baby Monitor
//


import UIKit

final class CameraPreviewView: BaseView {
    
    let mediaView = UIView()
    let babyNavigationItemView = BabyNavigationItemView()
    let cancelItemButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                             target: nil,
                                                             action: nil)
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [changeCameraButton, stopButton, microphoneButton])
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private let changeCameraButton = UIButton()
    private let microphoneButton = UIButton()
    private let stopButton = UIButton()
    
    override init() {
        super.init()
        setup()
    }
    
    //MARK: - Private functions
    private func setup() {
        backgroundColor = .gray
        
        addSubview(mediaView)
        addSubview(buttonsStackView)
        //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-65
        [changeCameraButton, stopButton, microphoneButton].forEach {
            $0.backgroundColor = .blue
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        mediaView.addConstraints { $0.equalSafeAreaEdges() }
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
            $0.equalTo(self, .bottom, .safeAreaBottom, constant: -20)
        ]}
    }
}
