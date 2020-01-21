//
//  SpecifyDeviceOnboardingViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift

final class SpecifyDeviceOnboardingViewModel {

    let analytics: AnalyticsManager
    var didSelectParent: (() -> Void)?
    var didSelectBaby: (() -> Void)?
    private(set) var cancelTap: Observable<Void>?
    let bag = DisposeBag()

    init(analytics: AnalyticsManager) {
        self.analytics = analytics
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
