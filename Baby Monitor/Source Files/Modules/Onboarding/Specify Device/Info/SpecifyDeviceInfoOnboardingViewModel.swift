//
//  SpecifyDeviceInfoOnboardingViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift

final class SpecifyDeviceInfoOnboardingViewModel {

    let bag = DisposeBag()
    let analyticsManager: AnalyticsManager
    private(set) var specifyDeviceTap: Observable<Void>?
    private(set) var cancelTap: Observable<Void>?

    init(analyticsManager: AnalyticsManager) {
        self.analyticsManager = analyticsManager
    }

    func attachInput(specifyDeviceTap: Observable<Void>, cancelTap: Observable<Void>) {
        self.specifyDeviceTap = specifyDeviceTap
        self.cancelTap = cancelTap
    }
    
    let descriptionText: NSMutableAttributedString = {
        let mainAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.customFont(withSize: .body, weight: .regular),
            .foregroundColor: UIColor.babyMonitorPurple
        ]
        let firstPartAttributedString = NSAttributedString(string: Localizable.Onboarding.SpecifyDevice.Info.descriptionFirstPart, attributes: mainAttributes)
        let oneTextAttributedString = NSAttributedString(string: Localizable.Onboarding.SpecifyDevice.Info.descriptionOneText, attributes: [
            .font: UIFont.customFont(withSize: .body, weight: .regular),
            .foregroundColor: UIColor.white])
        let middlePartAttributedString = NSAttributedString(string: Localizable.Onboarding.SpecifyDevice.Info.descriptionMiddlePart, attributes: mainAttributes)
        let theOtherTextAttributedString = NSAttributedString(string: Localizable.Onboarding.SpecifyDevice.Info.descriptionTheOtherText, attributes: [
            .font: UIFont.customFont(withSize: .body, weight: .regular),
            .foregroundColor: UIColor.white])
        let lastPartAttributedString = NSAttributedString(string: Localizable.Onboarding.SpecifyDevice.Info.descriptionLastPart, attributes: mainAttributes)
        let combinationText = NSMutableAttributedString()
        [firstPartAttributedString, oneTextAttributedString, middlePartAttributedString, theOtherTextAttributedString, lastPartAttributedString].forEach {
            combinationText.append($0)
        }
        return combinationText
    }()
    
}
