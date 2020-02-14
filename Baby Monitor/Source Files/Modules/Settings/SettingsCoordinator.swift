//
//  SettingsCoordinator.swift
//  Baby Monitor
//

import UIKit
import RxSwift

final class SettingsCoordinator: Coordinator {

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
        switch UserDefaults.appMode {
        case .parent:
            showParentSettings()
        case .baby:
            showBabySettings()
        case .none:
            break
        }
    }

    // MARK: - private functions
    private func showParentSettings() {
        let viewModel = ParentSettingsViewModel(babyModelController: appDependencies.databaseRepository,
                                                webSocketEventMessageService: appDependencies.webSocketEventMessageService,
                                                errorHandler: appDependencies.errorHandler,
                                                randomizer: appDependencies.randomizer,
                                                analytics: appDependencies.analytics)
        let settingsViewController = ParentSettingsViewController(viewModel: viewModel, appVersionProvider: appDependencies.appVersionProvider)
        settingsViewController.rx.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.connect(toParentSettingsViewModel: viewModel)
        })
        .disposed(by: bag)
        self.parentSettingsViewController = settingsViewController
        navigationController.pushViewController(settingsViewController, animated: true)
    }
    
    private func showBabySettings() {
        let viewModel = ServerSettingsViewModel(analytics: appDependencies.analytics)
        let settingsViewController = ServerSettingsViewController(viewModel: viewModel, appVersionProvider: appDependencies.appVersionProvider)
        settingsViewController.rx.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.connect(toBaseSettingsViewModel: viewModel)
        })
        .disposed(by: bag)
        navigationController.pushViewController(settingsViewController, animated: true)
    }
    
    private func connect(toBaseSettingsViewModel viewModel: BaseSettingsViewModelProtocol) {
        viewModel.resetAppTap?.subscribe(onNext: { [unowned self] in
            let continueHandler: (() -> Void) = { [weak self] in
                self?.appDependencies.applicationResetter.reset(isRemote: false)
                self?.onEnding?()
            }
            let continueAlertAction: (String, UIAlertAction.Style, (() -> Void)?) = (Localizable.General.continue, UIAlertAction.Style.default, continueHandler)
            let cancelAlertAction: (String, UIAlertAction.Style, (() -> Void)?) = (Localizable.General.cancel, UIAlertAction.Style.cancel, nil)
            AlertPresenter.showDefaultAlert(
                title: Localizable.General.warning,
                message: Localizable.Settings.clearDataAlertMessage,
                onViewController: self.navigationController,
                customActions: [continueAlertAction, cancelAlertAction])
        })
        .disposed(by: bag)
        viewModel.cancelTap?.subscribe(onNext: { [unowned self] in
            self.navigationController.popViewController(animated: true)
            self.onEnding?()
        })
        .disposed(by: bag)
    }

    private func connect(toParentSettingsViewModel viewModel: ParentSettingsViewModel) {
        viewModel.addPhotoTap?.subscribe(onNext: { [unowned self] button in
            self.showImagePickerAlert(sender: button)
        })
        .disposed(by: bag)
        viewModel.dismissImagePicker.subscribe(onNext: { [unowned self] in
            self.parentSettingsViewController?.dismiss(animated: true, completion: nil)
        })
        .disposed(by: bag)
        connect(toBaseSettingsViewModel: viewModel)
    }

    private func showImagePickerAlert(sender: UIView) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = parentSettingsViewController

        let alertController = UIAlertController(title: Localizable.Dashboard.chooseImage, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: Localizable.General.cancel, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        alertController.popoverPresentationController?.sourceView = sender
        alertController.popoverPresentationController?.sourceRect = sender.bounds
        
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
