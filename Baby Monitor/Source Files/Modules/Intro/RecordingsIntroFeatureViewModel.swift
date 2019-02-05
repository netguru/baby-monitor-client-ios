//
//  RecordingsIntroFeatureViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift

final class RecordingsIntroFeatureViewModel {
    
    let bag = DisposeBag()
    private(set) var startButtonTap: Observable<Void>?
    
    func attachInput(recordingsSwitchChange: Observable<Bool>, startButtonTap: Observable<Void>) {
        self.startButtonTap = startButtonTap
        recordingsSwitchChange.subscribe(onNext: { isOn in
            UserDefaults.isSendingCryingsAllowed = isOn
        })
        .disposed(by: bag)
    }
}
