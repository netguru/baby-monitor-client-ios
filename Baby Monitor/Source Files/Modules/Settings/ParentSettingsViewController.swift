//
//  ParentSettingsViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import StoreKit

final class ParentSettingsViewController: TypedViewController<ParentSettingsView>, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    private let viewModel: ParentSettingsViewModel
    private let bag = DisposeBag()

    init(viewModel: ParentSettingsViewModel, appVersionProvider: AppVersionProvider) {
        let appVersion = appVersionProvider.getAppVersionWithBuildNumber()
        self.viewModel = viewModel
        super.init(
            viewMaker: ParentSettingsView(appVersion: appVersion, voiceDetectionTitles: viewModel.voiceDetectionTitles, selectedVoiceModeIndex: viewModel.selectedVoiceModeIndex),
            analytics: viewModel.analytics,
            analyticsScreenType: .parentSettings)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViewModel()
    }

    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        viewModel.updatePhoto(image)
        viewModel.selectDismissImagePicker()
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
    }

    private func setupViewModel() {
        viewModel.attachInput(
            babyName: customView.rx.babyName.asObservable(),
            addPhotoTap: customView.rx.editPhotoTap.asObservable(),
            voiceDetectionTap: customView.rx.voiceModeTap.asObservable(),
            resetAppTap: customView.rx.resetButtonTap.asObservable(),
            cancelTap: customView.rx.cancelButtonTap.asObservable()
        )
        viewModel.baby
            .map { $0.name }
            .distinctUntilChanged()
            .bind(to: customView.rx.babyName)
            .disposed(by: bag)
        viewModel.baby
            .map { $0.photo }
            .distinctUntilChanged()
            .bind(to: customView.rx.babyPhoto)
            .disposed(by: bag)
    }

    private func handleRating() {
        SKStoreReviewController.requestReview()
        viewModel.analytics.logEvent(.rateUs)
    }
}
