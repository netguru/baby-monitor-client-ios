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
    
    private let memoryCleaner: MemoryCleanerProtocol
    private let bag = DisposeBag()
    
    init(memoryCleaner: MemoryCleanerProtocol) {
        self.memoryCleaner = memoryCleaner
    }
    
    func attachInput(resetAppTap: Observable<Void>, cancelTap: Observable<Void>, allowSwitchControlProperty: Observable<Bool>) {
        self.resetAppTap = resetAppTap
        self.cancelTap = cancelTap
        allowSwitchControlProperty.subscribe (onNext: { isOn in
            UserDefaults.isSendingCryingsAllowed = isOn
        })
        .disposed(by: bag)
    }
    
    func clearAllDataForNoneState() {
        memoryCleaner.cleanMemory()
        UserDefaults.appMode = .none
        UserDefaults.isSendingCryingsAllowed = false
    }
}
