//
//  OnboardingContinuableViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift

final class OnboardingContinuableViewModel {
    
    enum Role {
        case baby(BabyRole)
    }
    
    enum BabyRole {
        case connectToWiFi
        case putNextToBed
    }
    
    let role: Role
    let bag = DisposeBag()
    var title: String {
        switch role {
        case .baby(let babyRole):
            switch babyRole {
            case .connectToWiFi:
                return Localizable.Onboarding.connecting
            case .putNextToBed:
                return Localizable.Onboarding.Connecting.setupInformation
            }
        }
    }
    var description: String {
        switch role {
        case .baby(let babyRole):
            switch babyRole {
            case .connectToWiFi:
                return Localizable.Onboarding.Connecting.connectToWiFi
            case .putNextToBed:
                return Localizable.Onboarding.Connecting.placeDevice
            }
        }
    }
    var buttonTitle: String {
        switch role {
        case .baby(let babyRole):
            switch babyRole {
            case .connectToWiFi:
                return Localizable.Onboarding.Connecting.connectToWiFiButtonTitle
            case .putNextToBed:
                return Localizable.Onboarding.Connecting.startMonitoring
            }
        }
    }
    var image: UIImage {
        switch role {
        case .baby(let babyRole):
            switch babyRole {
            case .connectToWiFi:
                return #imageLiteral(resourceName: "onboarding-connecting")
            case .putNextToBed:
                return #imageLiteral(resourceName: "onboarding-camera")
            }
        }
    }
    var cancelTap: Observable<Void>?
    var nextButtonTap: Observable<Void>?
    
    init(role: Role) {
        self.role = role
    }
    
    func attachInput(buttonTap: Observable<Void>, cancelButtonTap: Observable<Void>) {
        cancelTap = cancelButtonTap
        nextButtonTap = buttonTap
    }
}
