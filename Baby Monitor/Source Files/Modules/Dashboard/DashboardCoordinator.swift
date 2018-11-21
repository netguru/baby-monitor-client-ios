//
//  DashboardCoordinator.swift
//  Baby Monitor
//

import UIKit
import RxCocoa
import RxSwift

final class DashboardCoordinator: Coordinator, BabiesViewShowable {

    var appDependencies: AppDependencies
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var switchBabyViewController: BabyMonitorGeneralViewController<SwitchBabyViewModel.Cell>?

    var onEnding: (() -> Void)?

    private weak var dashboardViewController: DashboardViewController?
    private weak var cameraPreviewViewController: CameraPreviewViewController?
    
    private let bag = DisposeBag()

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

        dashboardViewController.rx.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.connect(toDashboardViewModel: viewModel)
            })
            .disposed(by: bag)
        navigationController.pushViewController(dashboardViewController, animated: false)
    }

    // Prepare DashboardViewModel
    private func createDashboardViewModel() -> DashboardViewModel {
        let viewModel = DashboardViewModel(connectionChecker: appDependencies.connectionChecker, babyRepo: appDependencies.babiesRepository)
        return viewModel
    }
    
    private func connect(toDashboardViewModel viewModel: DashboardViewModel) {
        viewModel.showBabies?
            .subscribe(onNext: { [unowned self] in
                guard let dashboardViewController = self.dashboardViewController else {
                    return
                }
                self.toggleSwitchBabiesView(on: dashboardViewController, babyRepo: self.appDependencies.babiesRepository)
            })
            .disposed(by: bag)
        viewModel.liveCameraPreview?.subscribe(onNext: { [unowned self] in
                let viewModel = self.createCameraPreviewViewModel()
                let cameraPreviewViewController = CameraPreviewViewController(viewModel: viewModel)
                self.cameraPreviewViewController = cameraPreviewViewController
                let navigationController = UINavigationController(rootViewController: cameraPreviewViewController)
                self.navigationController.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: bag)
        viewModel.addPhoto?.subscribe(onNext: { [unowned self] in
                self.showImagePickerAlert()
            })
            .disposed(by: bag)
        viewModel.dismissImagePicker.subscribe(onNext: { [unowned self] in
                guard let dashboardViewController = self.dashboardViewController else {
                    return
                }
                dashboardViewController.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
    }

    // Prepare CameraPreviewViewModel
    private func createCameraPreviewViewModel() -> CameraPreviewViewModel {
        let viewModel = CameraPreviewViewModel(webRtcClientManager: appDependencies.webRtcClient(), webSocket: appDependencies.webSocket(appDependencies.urlConfiguration.url), babyRepo: appDependencies.babiesRepository, decoders: appDependencies.webRtcMessageDecoders)
        viewModel.didSelectCancel = { [weak self] in
            self?.navigationController.dismiss(animated: true, completion: nil)
        }
        viewModel.didSelectShowBabies = { [weak self] in
            guard let self = self, let cameraPreviewViewController = self.cameraPreviewViewController else {
                return
            }
            self.toggleSwitchBabiesView(on: cameraPreviewViewController, babyRepo: self.appDependencies.babiesRepository)
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
