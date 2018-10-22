//
//  DashboardCoordinator.swift
//  Baby Monitor
//

import UIKit

final class DashboardCoordinator: Coordinator, BabiesViewShowable {
    
    var appDependencies: AppDependencies
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var switchBabyViewController: BabyMonitorGeneralViewController?
    
    var onEnding: (() -> Void)?
    
    private weak var dashboardViewController: DashboardViewController?
    private weak var cameraPreviewViewController: CameraPreviewViewController?
    
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
    }
    
    func start() {
        showDashboard()
    }
    
    private func showDashboard() {
        let viewModel = createDashboardViewModel()
        let dashboardViewController = DashboardViewController(viewModel: viewModel)
        self.dashboardViewController = dashboardViewController
        navigationController.pushViewController(dashboardViewController, animated: false)
    }
    
    // Prepare DashboardViewModel
    private func createDashboardViewModel() -> DashboardViewModel {
        let viewModel = DashboardViewModel(babyService: appDependencies.babyService)
        viewModel.didSelectShowBabies = { [weak self] in
            guard let self = self, let dashboardViewController = self.dashboardViewController else {
                return
            }
            self.toggleSwitchBabiesView(on: dashboardViewController, babyService: self.appDependencies.babyService)
        }
        viewModel.didSelectLiveCameraPreview = { [weak self] in
            guard let self = self else {
                return
            }
            let viewModel = self.createCameraPreviewViewModel()
            let cameraPreviewViewController = CameraPreviewViewController(viewModel: viewModel)
            self.cameraPreviewViewController = cameraPreviewViewController
            let navigationController = UINavigationController(rootViewController: cameraPreviewViewController)
            self.navigationController.present(navigationController, animated: true, completion: nil)
        }
        viewModel.didSelectAddPhoto = { [weak self] in
            self?.showImagePickerAlert()
        }
        viewModel.didSelectDismissImagePicker = { [weak self] in
            guard let dashboardViewController = self?.dashboardViewController else {
                return
            }
            dashboardViewController.dismiss(animated: true, completion: nil)
        }
        return viewModel
    }
    
    // Prepare CameraPreviewViewModel
    private func createCameraPreviewViewModel() -> CameraPreviewViewModel {
        let viewModel = CameraPreviewViewModel(mediaPlayer: self.appDependencies.mediaPlayer, babyService: self.appDependencies.babyService)
        viewModel.didSelectCancel = { [weak self] in
            self?.navigationController.dismiss(animated: true, completion: nil)
        }
        viewModel.didSelectShowBabies = { [weak self] in
            guard let self = self, let cameraPreviewViewController = self.cameraPreviewViewController else {
                return
            }
            self.toggleSwitchBabiesView(on: cameraPreviewViewController, babyService: self.appDependencies.babyService)
        }
        return viewModel
    }
    
    // Show alert with camera or photo library options, after choosing show image picker or camera
    private func showImagePickerAlert() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = dashboardViewController

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
