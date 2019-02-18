//
//  ServerSettingsView.swift
//  Baby Monitor
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class ServerSettingsView: BaseSettingsView {
    
    let allowSwitch = BabyMonitorSwitch()
    private let allowLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.customFont(withSize: .body, weight: .medium)
        label.textColor = .white
        label.text = Localizable.Settings.allowSendingBabyVoice
        return label
    }()
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let mainAttributes = [
            NSAttributedString.Key.font: UIFont.customFont(withSize: .caption, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.babyMonitorBrownGray
        ]
        let firstPartAttributedString = NSAttributedString(string: Localizable.Settings.sendCryingsDescriptionFirstPart, attributes: mainAttributes)
        let withYourHelpAttributedString = NSAttributedString(string: Localizable.Settings.withYourHelp, attributes: mainAttributes)
        let babyMonitorAttributedString = NSAttributedString(string: Localizable.General.babyMonitor, attributes: [
                .font: UIFont.customFont(withSize: .caption, weight: .bold),
                .foregroundColor: UIColor.babyMonitorPurple
        ]
        )
        let lastPartAttributedString = NSAttributedString(string: Localizable.Settings.sendCryingsDescriptionSecondPart, attributes: mainAttributes)
        let breakAttributedString = NSAttributedString(string: " ")
        let combinationText = NSMutableAttributedString()
        [firstPartAttributedString, withYourHelpAttributedString, breakAttributedString, babyMonitorAttributedString, breakAttributedString, lastPartAttributedString].forEach {
            combinationText.append($0)
        }
        label.attributedText = combinationText
        return label
    }()
    private let informationImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "information"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// Initializes settings view
    override init() {
        super.init()
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .babyMonitorDarkPurple
    }
    
    private func setupLayout() {
        [allowLabel, allowSwitch, informationImageView, informationLabel].forEach { addSubview($0) }
        setupConstraints()
    }
    
    private func setupConstraints() {
        allowLabel.addConstraints {[
            $0.equalTo(buttonsStackView, .leading, .leading, constant: 2),
            $0.equalTo(self, .top, .safeAreaTop, constant: 46.5)
        ]
        }
        allowSwitch.addConstraints {[
            $0.equalTo(buttonsStackView, .trailing, .trailing),
            $0.equalTo(allowLabel, .top, .top)
        ]
        }
        informationImageView.addConstraints {[
            $0.equalTo(buttonsStackView, .leading, .leading),
            $0.equalTo(allowLabel, .top, .bottom, constant: 8.5)
        ]
        }
        informationLabel.addConstraints {[
            $0.equalTo(informationImageView, .leading, .trailing, constant: 15),
            $0.equalTo(allowLabel, .top, .bottom, constant: 6.5)
        ]
        }
    }
}

extension Reactive where Base: ServerSettingsView {
    
    var allowSwitchChange: ControlProperty<Bool> {
        return base.allowSwitch.rx.isOn
    }
}
