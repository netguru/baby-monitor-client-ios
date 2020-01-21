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
        navigationItem.leftBarButtonItem = customView.cancelItemButton
        view.backgroundColor = .babyMonitorDarkGray
        customView.setupBackgroundImage(UIImage())
        viewModel.attachInput(
            recordingsSwitchChange: customView.rx.recordingsSwitch.asObservable(),
            startButtonTap: customView.rx.startTap.asObservable(),
            cancelButtonTap: customView.rx.cancelTap.asObservable())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.analyticsManager.logScreen(.recordingsIntroFeature, className: className)
    }

}
