//
//  SpecifyDeviceOnboardingViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift

final class SpecifyDeviceOnboardingViewModel {

    let analyticsManager: AnalyticsManager
    var didSelectParent: (() -> Void)?
    var didSelectBaby: (() -> Void)?
    private(set) var cancelTap: Observable<Void>?
    let bag = DisposeBag()

    init(analyticsManager: AnalyticsManager) {
        self.analyticsManager = analyticsManager
    }

    func selectParent() {
        didSelectParent?()
    }
    
    func selectBaby() {
        didSelectBaby?()
    }
    
    func attachInput(cancelTap: Observable<Void>) {
        self.cancelTap = cancelTap
    }
}
