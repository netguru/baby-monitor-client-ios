//
//  TabBarCoordinator.swift
//  Baby Monitor
//

import UIKit
import RxSwift

final class TabBarCoordinator: Coordinator {
    
    var appDependencies: AppDependencies
    var navigationController: UINavigationController
    lazy var childCoordinators: [Coordinator] = [
        DashboardCoordinator(UINavigationController(), appDependencies: appDependencies),
        ActivityLogCoordinator(UINavigationController(), appDependencies: appDependencies),
        // TODO: Hidden for MVP
        // LullabiesCoordinator(UINavigationController(), appDependencies: appDependencies),
    ]
    var onEnding: (() -> Void)?
    
    private let tabBarController = TabBarController()
    private let disposeBag = DisposeBag()
    
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
        setup()
    }
    
    func start() {
        appDependencies.localNotificationService.getNotificationsAllowance { [unowned self] isGranted in
            if !isGranted {
                AlertPresenter.showDefaultAlert(title: Localizable.General.warning, message: Localizable.Errors.notificationsNotAllowed, onViewController: self.navigationController)
            }
        }
        appDependencies.clientService.cryingEventObservable.subscribe(onNext: { _ in
            AlertPresenter.showDefaultAlert(title: Localizable.Server.babyIsCrying, message: nil, onViewController: self.navigationController)
        }).disposed(by: disposeBag)
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(tabBarController, animated: true)
        childCoordinators.forEach { $0.start() }
    }
    
    // MARK: - private functions
    private func setup() {
        let settingsCoordinator = SettingsCoordinator(UINavigationController(), appDependencies: appDependencies)
        settingsCoordinator.onEnding = { [weak self] in
            // For now triggering settingsCoordinator onEnding is only in situation where user wants to clear all data
            switch UserDefaults.appMode {
            case .none:
                self?.onEnding?()
            case .parent, .baby:
                break
            }
        }
        childCoordinators.append(settingsCoordinator)
        let tabViewControllers = childCoordinators.map { $0.navigationController }
        tabBarController.setViewControllers(tabViewControllers, animated: false)
        tabBarController.setupTabBarItems()
    }
}
