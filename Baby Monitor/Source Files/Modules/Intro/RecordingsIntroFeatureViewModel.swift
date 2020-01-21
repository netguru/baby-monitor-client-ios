//
//  RecordingsIntroFeatureViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift

final class RecordingsIntroFeatureViewModel {
    
    let bag = DisposeBag()
    let analytics: AnalyticsManager
    private(set) var startButtonTap: Observable<Void>?
    private(set) var cancelButtonTap: Observable<Void>?

    init(analytics: AnalyticsManager) {
        self.analytics = analytics
    }

    func attachInput(recordingsSwitchChange: Observable<Bool>, startButtonTap: Observable<Void>, cancelButtonTap: Observable<Void>) {
        self.startButtonTap = startButtonTap
        self.cancelButtonTap = cancelButtonTap
        recordingsSwitchChange.subscribe(onNext: { isOn in
            UserDefaults.isSendingCryingsAllowed = isOn
        })
        .disposed(by: bag)
    }
}
