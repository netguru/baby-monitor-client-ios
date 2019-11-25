//
//  DashboardCoordinator.swift
//  Baby Monitor
//

import UIKit
import RxCocoa
import RxSwift

final class DashboardCoordinator: Coordinator {

    var appDependencies: AppDependencies
    lazy var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var onEnding: (() -> Void)?

    private weak var parentSettingsCoordinator: SettingsCoordinator?
    private weak var dashboardViewController: DashboardViewController?
    private weak var cameraPreviewViewController: CameraPreviewViewController?
    private let disposeBag = DisposeBag()

    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
    }

    func start() {
        setupResettingApp()
        setupParentSettingsCoordinator()
        showDashboard()
        appDependencies.localNotificationService.getNotificationsAllowance { [unowned self] isGranted in
            if !isGranted {
                AlertPresenter.showDefaultAlert(title: Localizable.General.warning, message: Localizable.Errors.notificationsNotAllowed, onViewController: self.navigationController)
            }
        }
    }
    
    private func setupResettingApp() {
        appDependencies.applicationResetter.localResetCompleted.asObservable()
            .distinctUntilChanged()
            .filter {
                $0 == true
            }.subscribe(onNext: {
                [weak self] resetCompleted in
                self?.onEnding?()
            }).disposed(by: disposeBag)
    }

    private func showDashboard() {
        let viewModel = createDashboardViewModel()
        let dashboardViewController = DashboardViewController(viewModel: viewModel)
        self.dashboardViewController = dashboardViewController

        dashboardViewController.rx.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.connect(toDashboardViewModel: viewModel)
            })
            .disposed(by: viewModel.bag)
        navigationController.setViewControllers([dashboardViewController], animated: true)
    }

    // Prepare DashboardViewModel
    private func createDashboardViewModel() -> DashboardViewModel {
        let viewModel = DashboardViewModel(
            connectionChecker: appDependencies.connectionChecker, babyModelController: appDependencies.databaseRepository,
            webSocketEventMessageService: appDependencies.webSocketEventMessageService.get(), microphonePermissionProvider: appDependencies.microphonePermissionProvider)
        return viewModel
    }
    
    private func connect(toDashboardViewModel viewModel: DashboardViewModel) {
        viewModel.liveCameraPreview?.subscribe(onNext: { [unowned self] in
            let viewModel = self.createCameraPreviewViewModel()
            let cameraPreviewViewController = CameraPreviewViewController(viewModel: viewModel)
            cameraPreviewViewController.rx.viewDidLoad.subscribe(onNext: { [unowned self] in
                self.connect(to: viewModel)
            })
                .disposed(by: viewModel.bag)
            self.cameraPreviewViewController = cameraPreviewViewController
            self.navigationController.pushViewController(cameraPreviewViewController, animated: true)
        })
            .disposed(by: viewModel.bag)
        viewModel.activityLogTap?.subscribe(onNext: { [unowned self] in
            let viewModel = self.createActivityLogViewModel()
            let viewController = ActivityLogViewController(viewModel: viewModel)
            self.navigationController.pushViewController(viewController, animated: true)
        })
            .disposed(by: viewModel.bag)
        viewModel.settingsTap?.subscribe(onNext: { [unowned self] in
            self.parentSettingsCoordinator?.start()
        })
            .disposed(by: viewModel.bag)
    }
    
    private func setupParentSettingsCoordinator() {
        let parentSettingsCoordinator = SettingsCoordinator(navigationController, appDependencies: appDependencies)
        childCoordinators.append(parentSettingsCoordinator)
        parentSettingsCoordinator.onEnding = { [unowned self] in
            switch UserDefaults.appMode {
            case .none:
                self.onEnding?()
            case .parent:
                if let coordinator = self.parentSettingsCoordinator {
                    self.remove(coordinator)
                }
                self.setupParentSettingsCoordinator()
            case .baby:
                break
            }
        }
        self.parentSettingsCoordinator = parentSettingsCoordinator
    }
    
    private func createActivityLogViewModel() -> ActivityLogViewModel {
        let viewModel = ActivityLogViewModel(databaseRepository: appDependencies.databaseRepository)
        viewModel.didSelectCancel = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        return viewModel
    }

    // Prepare CameraPreviewViewModel
    private func createCameraPreviewViewModel() -> CameraPreviewViewModel {
        let viewModel = CameraPreviewViewModel(
            webSocketWebRtcService: appDependencies.webSocketWebRtcService,
            babyModelController: appDependencies.databaseRepository,
            connectionChecker: appDependencies.connectionChecker,
            socketCommunicationManager: appDependencies.socketCommunicationsManager)
        return viewModel
    }
    
    private func connect(to viewModel: CameraPreviewViewModel) {
        viewModel.cancelTap?.subscribe(onNext: { [weak self] _ in
            self?.navigationController.popViewController(animated: true)
        })
            .disposed(by: viewModel.bag)
        viewModel.settingsTap?.subscribe(onNext: { [weak self] _ in
            self?.parentSettingsCoordinator?.start()
        })
            .disposed(by: viewModel.bag)
    }
}
