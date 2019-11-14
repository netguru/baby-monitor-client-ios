//
//  ServerSettingsViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import RxCocoa

final class ServerSettingsViewModel: BaseSettingsViewModelProtocol {
    
    var isSendingCryingsAllowed: Bool {
        return UserDefaults.isSendingCryingsAllowed
    }
    private(set) var resetAppTap: Observable<Void>?
    private(set) var cancelTap: Observable<Void>?
    
    private let bag = DisposeBag()
    
    func attachInput(resetAppTap: Observable<Void>, cancelTap: Observable<Void>, allowSwitchControlProperty: Observable<Bool>) {
        self.resetAppTap = resetAppTap
        self.cancelTap = cancelTap
        allowSwitchControlProperty.subscribe (onNext: { isOn in
            UserDefaults.isSendingCryingsAllowed = isOn
        })
        .disposed(by: bag)
    }
}
