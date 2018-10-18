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
            let cameraPreviewViewController = CameraPreviewViewController(viewModel: viewModel)
            self.cameraPreviewViewController = cameraPreviewViewController
            let navigationController = UINavigationController(rootViewController: cameraPreviewViewController)
            self.navigationController.present(navigationController, animated: true, completion: nil)
        }
        viewModel.didSelectAddPhoto = { [weak self] in
            self?.showImagePicker()
        }
        viewModel.didSelectDismissImagePicker = { [weak self] in
            guard let dashboardViewController = self?.dashboardViewController else {
                return
            }
            dashboardViewController.dismiss(animated: true, completion: nil)
        }
        
        let dashboardViewController = DashboardViewController(viewModel: viewModel)
        self.dashboardViewController = dashboardViewController
        navigationController.pushViewController(dashboardViewController, animated: false)
    }
    
    private func showImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = dashboardViewController

        let alertController = UIAlertController(title: Localizable.Dashboard.chooseImage, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: Localizable.General.cancel, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: Localizable.Dashboard.camera, style: .default, handler: { (action) in
                imagePickerController.sourceType = .camera
                self.navigationController.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: Localizable.Dashboard.photoLibrary, style: .default, handler: { (action) in
                imagePickerController.sourceType = .photoLibrary
                self.navigationController.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        navigationController.present(alertController, animated: true, completion: nil)
    }
}
