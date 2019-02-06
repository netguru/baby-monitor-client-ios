//
//  RecordingsIntroFeatureViewController.swift
//  Baby Monitor
//

import UIKit
import Foundation
import RxSwift

final class RecordingsIntroFeatureViewController: TypedViewController<SendRecordingsIntroFeatureView> {
    
    private let viewModel: RecordingsIntroFeatureViewModel
    
    init(viewModel: RecordingsIntroFeatureViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: SendRecordingsIntroFeatureView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .babyMonitorDarkGray
        customView.setupBackgroundImage(UIImage())
        viewModel.attachInput(
            recordingsSwitchChange: customView.rx.recordingsSwitch.asObservable(),
            startButtonTap: customView.rx.startTap.asObservable())
    }
}
