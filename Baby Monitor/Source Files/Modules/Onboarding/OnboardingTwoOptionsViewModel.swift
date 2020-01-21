//
//  OnboardingTwoOptionsViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift

final class OnboardingTwoOptionsViewModel {
    var upButtonTap: Observable<Void>?
    var bottomButtonTap: Observable<Void>?
    let bag = DisposeBag()
    let title = Localizable.Onboarding.BabySetup.permissionsDenided
    let image = #imageLiteral(resourceName: "onboarding-error")
    let mainDescription = Localizable.Onboarding.BabySetup.permissionsDenidedText
    let secondaryDescription = NSAttributedString(string: Localizable.Onboarding.BabySetup.permissionsDenidedQuestion) 
    let upButtonTitle = Localizable.General.retry
    let bottomButtonTitle = Localizable.General.imSure
    let analyticsManager: AnalyticsManager

    init(analyticsManager: AnalyticsManager) {
        self.analyticsManager = analyticsManager
    }

    func attachInput(upButtonTap: Observable<Void>, bottomButtonTap: Observable<Void>) {
        self.upButtonTap = upButtonTap
        self.bottomButtonTap = bottomButtonTap
    }
}
