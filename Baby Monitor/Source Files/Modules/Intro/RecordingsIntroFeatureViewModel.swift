//
//  RecordingsIntroFeatureViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift

final class RecordingsIntroFeatureViewModel: BaseViewModel {
    
    let bag = DisposeBag()
    private(set) var startButtonTap: Observable<Void>?
    private(set) var cancelButtonTap: Observable<Void>?

    func attachInput(recordingsSwitchChange: Observable<Bool>, startButtonTap: Observable<Void>, cancelButtonTap: Observable<Void>) {
        self.startButtonTap = startButtonTap
        self.cancelButtonTap = cancelButtonTap
        recordingsSwitchChange.subscribe(onNext: { isOn in
            UserDefaults.isSendingCryingsAllowed = isOn
        })
        .disposed(by: bag)
    }
}
