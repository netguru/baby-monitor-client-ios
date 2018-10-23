//
//  CameraPreviewView.swift
//  Baby Monitor
//

import UIKit

final class CameraPreviewView: BaseView {
    
    private enum Constants {
        static let mainButtonWidthHeight: CGFloat = 70
        static let secondaryButtonWidthHeight: CGFloat = 50
    }
    
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
    
    // MARK: - Private functions
    private func setup() {
        backgroundColor = .gray
        
        addSubview(mediaView)
        addSubview(buttonsStackView)
        [stopButton, microphoneButton, changeCameraButton].forEach {
            $0.layer.cornerRadius = Constants.secondaryButtonWidthHeight / 2
            $0.backgroundColor = .blue
        }
        stopButton.layer.cornerRadius = Constants.mainButtonWidthHeight / 2
        changeCameraButton.backgroundColor = .gray
        changeCameraButton.setImage(#imageLiteral(resourceName: "switchCamera"), for: .normal)
        stopButton.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
        microphoneButton.setImage(#imageLiteral(resourceName: "microphone"), for: .normal)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        mediaView.addConstraints { $0.equalSafeAreaEdges() }
        [changeCameraButton, microphoneButton].forEach {
            $0.addConstraints {[
                $0.equalConstant(.width, Constants.secondaryButtonWidthHeight),
                $0.equalConstant(.height, Constants.secondaryButtonWidthHeight)
            ]
            }
        }
        
        stopButton.addConstraints {[
            $0.equalConstant(.width, Constants.mainButtonWidthHeight),
            $0.equalConstant(.height, Constants.mainButtonWidthHeight)
        ]
        }
        
        buttonsStackView.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.width, multiplier: 0.8),
            $0.equalTo(self, .bottom, .safeAreaBottom, constant: -20)
        ]
        }
    }
}
