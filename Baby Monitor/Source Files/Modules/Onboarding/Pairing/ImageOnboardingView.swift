//
//  ImageOnboardingView.swift
//  Baby Monitor
//

import UIKit

final class ImageOnboardingView: BaseOnboardingView {
    
    enum `Role` {
        case pairing(PairingRole)
        case connecting
        
        enum PairingRole {
            case shareLink, pairing, error, pairingDone, allDone
        }
        
        var title: String {
            switch self {
            case .pairing(let pairingRole):
                switch pairingRole {
                case .shareLink:
                    return Localizable.Onboarding.Pairing.hello
                case .pairing:
                    return Localizable.Onboarding.connecting
                case .error:
                    return Localizable.Onboarding.connecting
                case .pairingDone:
                    return Localizable.Onboarding.connecting
                case .allDone:
                    return Localizable.Onboarding.Pairing.allDone
                }
            case .connecting:
                return Localizable.Onboarding.connecting
            }
        }
        
        var description: String {
            switch self {
            case .pairing(let pairingRole):
                switch pairingRole {
                case .shareLink:
                    return Localizable.Onboarding.Pairing.timeToInstallBabyMonitor
                case .pairing:
                    return Localizable.Onboarding.Pairing.searchingForSecondDevice
                case .error:
                    return Localizable.Onboarding.Pairing.error
                case .pairingDone:
                    return Localizable.Onboarding.Pairing.done
                case .allDone:
                    return Localizable.Onboarding.Pairing.startUsingBabyMonitor
                }
            case .connecting:
                return Localizable.Onboarding.connectToWiFi
            }
        }
        
        var nextButtonTitle: String {
            switch self {
            case .pairing(let pairingRole):
                switch pairingRole {
                case .shareLink:
                    return Localizable.Onboarding.Pairing.done
                case .pairing:
                    return ""
                case .error:
                    return Localizable.Onboarding.Pairing.tryAgain
                case .pairingDone:
                    return Localizable.Onboarding.continue
                case .allDone:
                    return Localizable.Onboarding.Pairing.getStarted
                }
            case .connecting:
                return Localizable.Onboarding.continue
            }
        }

        var image: UIImage {
            switch self {
            case .pairing(let pairingRole):
                switch pairingRole {
                case .shareLink:
                    return #imageLiteral(resourceName: "onboarding-shareLink")
                case .pairing:
                    return #imageLiteral(resourceName: "onboarding-oval")
                case .error:
                    return #imageLiteral(resourceName: "onboarding-error")
                case .pairingDone:
                    return #imageLiteral(resourceName: "onboarding-completed")
                case .allDone:
                    return UIImage()
                }
            case .connecting:
                return UIImage()
            }
        }
    }
    
    lazy var nextButtonObservable = nextButton.rx.tap.asObservable()
    
    private let role: Role
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var nextButton = OnboardingButton(title: role.nextButtonTitle)
    
    init(role: Role) {
        self.role = role
        super.init()
        setup(role: role)
    }
    
    private func setup(role: Role) {
        updateTitle(role.title)
        updateDescription(role.description)
        imageView.image = role.image
        
        [imageView, nextButton].forEach {
            addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.centerY, constant: -17),
            $0.equalConstant(.width, 80),
            $0.equalTo($0, .height, .width)
        ]
        }
        nextButton.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.bottom, constant: -32),
            $0.equalConstant(.height, 56)
        ]
        }
        nextButton.leadingAnchor.constraint(equalTo: titleLeadingAnchor).isActive = true
    }
}
