//
//  OnboardingTwoOptionsViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift

final class OnboardingTwoOptionsViewModel: BaseViewModel {
    var upButtonTap: Observable<Void>?
    var bottomButtonTap: Observable<Void>?
    let bag = DisposeBag()
    var title: String {
        switch permissionProvider.deniedPermissions {
        case .cameraAndMicrophone:
            return Localizable.Onboarding.BabySetup.cameraAndMicrophonePermissionsDenied
        case .onlyCamera:
            return Localizable.Onboarding.BabySetup.cameraPermissionsDenied
        case .onlyMicrophone:
            return Localizable.Onboarding.BabySetup.microphonePermissionsDenied
        case .none:
            assertionFailure("The view should not be loaded in the case when permissions granted")
            return ""
        }
    }
    let image = #imageLiteral(resourceName: "onboarding-error")
    let mainDescription = Localizable.Onboarding.BabySetup.permissionsDenidedText
    let secondaryDescription = NSAttributedString(string: Localizable.Onboarding.BabySetup.permissionsDenidedQuestion) 
    let upButtonTitle = Localizable.General.retry
    let bottomButtonTitle = Localizable.General.imSureExitApp
    private let permissionProvider: PermissionsProvider

    init(permissionProvider: PermissionsProvider, analytics: AnalyticsManager) {
        self.permissionProvider = permissionProvider
        super.init(analytics: analytics)
    }

    func attachInput(upButtonTap: Observable<Void>, bottomButtonTap: Observable<Void>) {
        self.upButtonTap = upButtonTap
        self.bottomButtonTap = bottomButtonTap
    }
}
