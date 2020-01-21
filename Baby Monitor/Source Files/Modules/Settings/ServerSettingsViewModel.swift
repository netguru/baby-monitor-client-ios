//
//  ServerSettingsViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import RxCocoa

final class ServerSettingsViewModel: BaseSettingsViewModelProtocol {

    let analyticsManager: AnalyticsManager
    var isSendingCryingsAllowed: Bool {
        return UserDefaults.isSendingCryingsAllowed
    }
    private(set) var resetAppTap: Observable<Void>?
    private(set) var cancelTap: Observable<Void>?
    
    private let bag = DisposeBag()

    init(analyticsManager: AnalyticsManager) {
        self.analyticsManager = analyticsManager
    }

    func attachInput(resetAppTap: Observable<Void>, cancelTap: Observable<Void>, allowSwitchControlProperty: Observable<Bool>) {
        self.resetAppTap = resetAppTap
        self.cancelTap = cancelTap
        allowSwitchControlProperty.subscribe (onNext: { isOn in
            UserDefaults.isSendingCryingsAllowed = isOn
        })
        .disposed(by: bag)
    }
}
