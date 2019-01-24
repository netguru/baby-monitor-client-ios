//
//  ActivityLogCoordinator.swift
//  Baby Monitor
//

import UIKit
import RxSwift

final class ActivityLogCoordinator: Coordinator {
    
    var appDependencies: AppDependencies
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var onEnding: (() -> Void)?

    private var activityLogViewController: BabyMonitorGeneralViewController<ActivityLogEvent>?
    private let bag = DisposeBag()
    
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.appDependencies = appDependencies
        self.navigationController = navigationController
    }
    
    func start() {
        showActivityLog()
    }
    
    // MARK: - private functions
    private func showActivityLog() {
        let viewModel = ActivityLogViewModel(databaseRepository: appDependencies.databaseRepository)
        activityLogViewController = BabyMonitorGeneralViewController(viewModel: AnyBabyMonitorGeneralViewModelProtocol<ActivityLogEvent>(viewModel: viewModel), type: .activityLog)
        navigationController.pushViewController(activityLogViewController!, animated: false)
    }}
