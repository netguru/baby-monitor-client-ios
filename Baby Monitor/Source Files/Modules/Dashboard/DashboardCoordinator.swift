//
//  DashboardCoordinator.swift
//  Baby Monitor
//

import UIKit
import RxCocoa
import RxSwift

final class DashboardCoordinator: Coordinator {

    var appDependencies: AppDependencies
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
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
        let viewModel = DashboardViewModel(connectionChecker: appDependencies.connectionChecker, babyModelController: appDependencies.databaseRepository)
        return viewModel
    }
    
    private func connect(toDashboardViewModel viewModel: DashboardViewModel) {
        viewModel.liveCameraPreview?.subscribe(onNext: { [unowned self] in
                let viewModel = self.createCameraPreviewViewModel()
                let cameraPreviewViewController = CameraPreviewViewController(viewModel: viewModel)
                self.cameraPreviewViewController = cameraPreviewViewController
                let navigationController = UINavigationController(rootViewController: cameraPreviewViewController)
                self.navigationController.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: viewModel.bag)
//        viewModel.activityLogTap?.subscribe(onNext: { [unowned self] in
//            let viewModel = createActivityLogViewModel()
//            let viewController = ActivityLogViewController
//        })
    }
    
    private func createActivityLogViewModel() -> ActivityLogViewModel {
        let viewModel = ActivityLogViewModel(databaseRepository: appDependencies.databaseRepository)
        return viewModel
    }

    // Prepare CameraPreviewViewModel
    private func createCameraPreviewViewModel() -> CameraPreviewViewModel {
        let viewModel = CameraPreviewViewModel(webSocketWebRtcService: appDependencies.webSocketWebRtcService(appDependencies.webRtcClient()), babyModelController: appDependencies.databaseRepository)
        viewModel.didSelectCancel = { [weak self] in
            self?.navigationController.dismiss(animated: true, completion: nil)
        }
        return viewModel
    }
}
