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
        let viewModel = DashboardViewModel()
        viewModel.didSelectShowBabies = { [weak self] in
            guard let dashboardViewController = self?.dashboardViewController else {
                return
            }
            self?.toggleSwitchBabiesView(on: dashboardViewController)
        }
        viewModel.didSelectLiveCameraPreview = { [weak self] in
            guard let self = self else {
                return
            }
            
            let viewModel = CameraPreviewViewModel(mediaPlayer: self.appDependencies.mediaPlayer)
            viewModel.didSelectCancel = { [weak self] in
                self?.navigationController.dismiss(animated: true, completion: nil)
            }
            viewModel.didSelectShowBabies = { [weak self] in
                guard let cameraPreviewViewController = self?.cameraPreviewViewController else {
                    return
                }
                self?.toggleSwitchBabiesView(on: cameraPreviewViewController)
            }
            let cameraPreviewViewController = CameraPreviewViewController(viewModel: viewModel)
            self.cameraPreviewViewController = cameraPreviewViewController
            let navigationController = UINavigationController(rootViewController: cameraPreviewViewController)
            self.navigationController.present(navigationController, animated: true, completion: nil)
        }
        let dashboardViewController = DashboardViewController(viewModel: viewModel)
        self.dashboardViewController = dashboardViewController
        navigationController.pushViewController(dashboardViewController, animated: false)
    }
}
