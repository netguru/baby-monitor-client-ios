//
//  TabBarCoordinator.swift
//  Baby Monitor
//

import UIKit

final class TabBarCoordinator: Coordinator {
    
    var appDependencies: AppDependencies
    var navigationController: UINavigationController
    lazy var childCoordinators: [Coordinator] = [
        DashboardCoordinator(UINavigationController(), appDependencies: appDependencies),
        ActivityLogCoordinator(UINavigationController(), appDependencies: appDependencies),
        // TODO: Hidden for MVP
        // LullabiesCoordinator(UINavigationController(), appDependencies: appDependencies),
        SettingsCoordinator(UINavigationController(), appDependencies: appDependencies)
    ]
    var onEnding: (() -> Void)?
    
    private let tabBarController = TabBarController()
    
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
        setup()
    }
    
    func start() {
        appDependencies.websocketsService.play()
        appDependencies.websocketsService.onCryingEventOccurence = { [unowned self] in
            AlertPresenter.showDefaultAlert(title: Localizable.Server.babyIsCrying, message: nil, onViewController: self.navigationController)
        }
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(tabBarController, animated: true)
        childCoordinators.forEach { $0.start() }
        appDependencies.localNotificationService.getNotificationsAllowance { [unowned self] isGranted in
            if !isGranted {
                AlertPresenter.showDefaultAlert(title: Localizable.General.warning, message: Localizable.Errors.notificationsNotAllowed, onViewController: self.navigationController)
            }
        }
    }
    
    // MARK: - private functions
    private func setup() {
        let tabViewControllers = childCoordinators.map { $0.navigationController }
        tabBarController.setViewControllers(tabViewControllers, animated: false)
        tabBarController.setupTabBarItems()
    }
}
