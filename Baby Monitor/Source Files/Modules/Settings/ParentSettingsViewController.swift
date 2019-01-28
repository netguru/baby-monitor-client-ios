//
//  ParentSettingsViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift

class ParentSettingsViewController: TypedViewController<SettingsView>, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    private let viewModel: ParentSettingsViewModel
    private let bag = DisposeBag()

    init(viewModel: ParentSettingsViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: SettingsView())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.babyMonitorNonTranslucentWhite, .font: UIFont.customFont(withSize: .body)]
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
        navigationItem.title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow_back"), style: .plain, target: self, action: #selector(cancel))
        customView.rx.rateButtonTap.asObservable().subscribe(onNext: { [weak self] _ in
            self?.handleRating()
        })
        .disposed(by: bag)
    }

    private func setupViewModel() {
        viewModel.attachInput(babyName: customView.rx.babyName.asObservable(), addPhotoTap: customView.rx.editPhotoTap.asObservable(), resetAppTap: customView.rx.resetButtonTap.asObservable())
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

    @objc
    private func cancel() {
        navigationController?.popViewController(animated: true)
    }

    // TODO: - Redirect to Appstore and give possibility of rating after app will be on Appstore
    private func handleRating(){}
}
