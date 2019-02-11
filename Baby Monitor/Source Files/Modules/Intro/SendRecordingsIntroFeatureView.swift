//
//  SendRecordingsIntroFeatureView.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import RxCocoa

final class SendRecordingsIntroFeatureView: IntroFeatureView {
    
    let cancelItemButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowBack"),
                                           style: .plain,
                                           target: nil,
                                           action: nil)
    let recordingsSwitch = BabyMonitorSwitch()
    let startButton = RoundedRectangleButton(title: Localizable.General.letsStart, backgroundColor: .babyMonitorPurple)
    
    init() {
        super.init(role: .recordings)
        setup()
    }
    
    private func setup() {
        startButton.titleLabel?.font = UIFont.customFont(withSize: .small, weight: .bold)
        rightButton.removeFromSuperview()
        leftButton.removeFromSuperview()
        addSubview(recordingsSwitch)
        addSubview(startButton)
        titleLabel.textAlignment = .left
        titleLabelConstraints.forEach {
            $0.isActive = false
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        recordingsSwitch.addConstraints {[
            $0.equalTo(titleLabel, .leading, .trailing, constant: 13),
            $0.equalTo(titleLabel, .top, .top)
        ]
        }
        titleLabel.addConstraints {[
            $0.equalTo(imageView, .top, .bottom, constant: 42),
            $0.equal(.leading, constant: 50)
        ]
        }
        startButton.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.leading, constant: 24),
            $0.equalTo(self, .bottom, .safeAreaBottom, constant: -32),
            $0.equalConstant(.height, 56)
        ]
        }
    }
}

extension Reactive where Base: SendRecordingsIntroFeatureView {
    
    var startTap: ControlEvent<Void> {
        return base.startButton.rx.tap
    }
    
    var recordingsSwitch: ControlProperty<Bool> {
        return base.recordingsSwitch.rx.isOn
    }
    
    var cancelTap: ControlEvent<Void> {
        return base.cancelItemButton.rx.tap
    }
}
