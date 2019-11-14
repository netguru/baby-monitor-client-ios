//
//  ImageOnboardingView.swift
//  Baby Monitor
//

import UIKit

class ImageOnboardingView: OldBaseOnboardingView {
    
    enum `Role` {
        case pairing(PairingRole)
        case connecting(ConnectingRole)
        
        enum PairingRole {
            case shareLink, pairing, error, pairingDone, allDone
        }
        
        enum ConnectingRole {
            case connectToWiFi, setupInformation
        }
        
        var title: String {
            switch self {
            case .pairing(let pairingRole):
                switch pairingRole {
                case .shareLink:
                    return Localizable.Onboarding.Pairing.hello
                case .pairing, .error, .pairingDone:
                    return Localizable.Onboarding.connecting
                case .allDone:
                    return Localizable.Onboarding.Pairing.allDone
                }
            case .connecting(let connectingRole):
                switch connectingRole {
                case .connectToWiFi:
                    return Localizable.Onboarding.connecting
                case .setupInformation:
                    return Localizable.Onboarding.Connecting.setupInformation
                }
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
            case .connecting(let connectingRole):
                switch connectingRole {
                case .connectToWiFi:
                    return Localizable.Onboarding.Connecting.connectToWiFi
                case .setupInformation:
                    return Localizable.Onboarding.Connecting.placeDevice
                }
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
            case .connecting(let connectingRole):
                switch connectingRole {
                case .connectToWiFi:
                    return Localizable.Onboarding.continue
                case .setupInformation:
                    return Localizable.Onboarding.Connecting.startMonitoring
                }
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
            case .connecting(let connectingRole):
                switch connectingRole {
                case .connectToWiFi:
                    return #imageLiteral(resourceName: "onboarding-connecting")
                case .setupInformation:
                    return #imageLiteral(resourceName: "onboarding-camera")
                }
            }
        }
    }
    
    var imageCenterYAnchor: NSLayoutYAxisAnchor {
        return imageView.centerYAnchor
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
        setup()
    }
    
    func hideNextButton() {
        nextButton.isHidden = true
    }
    
    private func setup() {
        updateTitle(role.title)
        updateDescription(role.description)
        imageView.image = role.image
        
        switch role {
        case .pairing(.error):
            nextButton.backgroundColor = .clear
            nextButton.setTitleColor(.black, for: .normal)
            nextButton.layer.borderColor = UIColor.babyMonitorPurple.cgColor
            nextButton.layer.borderWidth = 2
        case .pairing(.allDone):
            changeStyleToBluish()
            nextButton.backgroundColor = .black
            nextButton.setTitleColor(.white, for: .normal)
        default:
            break
        }
        
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
            $0.equal(.safeAreaBottom, constant: -32),
            $0.equalConstant(.height, 56)
        ]
        }
        nextButton.leadingAnchor.constraint(equalTo: titleLeadingAnchor).isActive = true
    }
}
