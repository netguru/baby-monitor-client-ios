//
//  ActivityLogCoordinator.swift
//  Baby Monitor
//

import UIKit
import RxSwift

final class ActivityLogCoordinator: Coordinator, BabiesViewShowable {
    
    var appDependencies: AppDependencies
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var switchBabyViewController: BabyMonitorGeneralViewController<SwitchBabyViewModel.Cell>?
    
    var onEnding: (() -> Void)?

    private var activityLogViewController: BabyMonitorGeneralViewController<Baby>?
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
        let viewModel = ActivityLogViewModel(babyRepo: appDependencies.babiesRepository)
        
        activityLogViewController = BabyMonitorGeneralViewController(viewModel: AnyBabyMonitorGeneralViewModelProtocol<Baby>(viewModel: viewModel), type: .activityLog)
        activityLogViewController?.rx.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.connect(toActivityLogViewModel: viewModel)
            })
            .disposed(by: bag)
        navigationController.pushViewController(activityLogViewController!, animated: false)
    }
    
    private func connect(toActivityLogViewModel viewModel: ActivityLogViewModel) {
        viewModel.showBabies?
            .subscribe(onNext: { [weak self] in
                guard let self = self, let activityLogViewController = self.activityLogViewController else {
                    return
                }
                self.toggleSwitchBabiesView(on: activityLogViewController, babyRepo: self.appDependencies.babiesRepository)
            })
            .disposed(by: bag)
    }
}
