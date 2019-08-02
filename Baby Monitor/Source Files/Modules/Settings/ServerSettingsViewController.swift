//
//  ServerSettingsViewController.swift
//  Baby Monitor
//

import Foundation
import UIKit
import RxSwift
import StoreKit

final class ServerSettingsViewController: TypedViewController<ServerSettingsView> {
    
    private let viewModel: ServerSettingsViewModel
    private let bag = DisposeBag()
    
    init(viewModel: ServerSettingsViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: ServerSettingsView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView.allowSwitch.setOn(viewModel.isSendingCryingsAllowed, animated: false)
        setup()
    }
    
    // MARK: - Private functions
    private func setup() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.babyMonitorNonTranslucentWhite, .font: UIFont.customFont(withSize: .body)]
        navigationItem.title = "Settings"
        navigationItem.leftBarButtonItem = customView.cancelButtonItem
        customView.rx.rateButtonTap.asObservable().subscribe(onNext: { [weak self] _ in
            self?.handleRating()
        })
        .disposed(by: bag)
        setupViewModel()
    }
    
    private func setupViewModel() {
        viewModel.attachInput(
            resetAppTap: customView.rx.resetButtonTap.asObservable(),
            cancelTap: customView.rx.cancelButtonTap.asObservable(),
            allowSwitchControlProperty: customView.rx.allowSwitchChange.asObservable())
    }
    
    private func handleRating() {
        SKStoreReviewController.requestReview()
    }
}
