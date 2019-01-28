//
//  ParentSettingsCoordinator.swift
//  Baby Monitor
//

import UIKit
import RxSwift

final class ParentSettingsCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var appDependencies: AppDependencies
    var navigationController: UINavigationController
    var onEnding: (() -> Void)?

    private weak var parentSettingsViewController: ParentSettingsViewController?

    private let bag = DisposeBag()

    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.appDependencies = appDependencies
        self.navigationController = navigationController
    }

    func start() {
        showSettings()
    }

    // MARK: - private functions
    private func showSettings() {
        let viewModel = ParentSettingsViewModel(babyRepo: appDependencies.babiesRepository)
        let settingsViewController = ParentSettingsViewController(viewModel: viewModel)
        settingsViewController.rx.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.connect(toParentSettingsViewModel: viewModel)
        })
        .disposed(by: bag)
        self.parentSettingsViewController = settingsViewController
        navigationController.pushViewController(settingsViewController, animated: false)
    }

    private func connect(toParentSettingsViewModel viewModel: ParentSettingsViewModel) {
        viewModel.addPhoto?.subscribe(onNext: { [unowned self] in
            self.showImagePickerAlert()
        })
        .disposed(by: bag)
        viewModel.dismissImagePicker.subscribe(onNext: { [unowned self] in
            guard let parentSettingsViewController = self.parentSettingsViewController else {
                return
            }
            parentSettingsViewController.dismiss(animated: true, completion: nil)
        })
        .disposed(by: bag)
    }

    private func showImagePickerAlert() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = parentSettingsViewController

        let alertController = UIAlertController(title: Localizable.Dashboard.chooseImage, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: Localizable.General.cancel, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: Localizable.Dashboard.camera, style: .default, handler: { action in
                imagePickerController.sourceType = .camera
                self.navigationController.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: Localizable.Dashboard.photoLibrary, style: .default, handler: { action in
                imagePickerController.sourceType = .photoLibrary
                self.navigationController.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }

        navigationController.present(alertController, animated: true, completion: nil)
    }
}
