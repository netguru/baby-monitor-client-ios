//
//  LullabiesCoordinator.swift
//  Baby Monitor
//

import UIKit
import RxSwift

final class LullabiesCoordinator: Coordinator, BabiesViewShowable {
    
    var appDependencies: AppDependencies
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var switchBabyViewController: BabyMonitorGeneralViewController<SwitchBabyViewModel.Cell>?
    var onEnding: (() -> Void)?
    
    private var lullabiesViewController: BabyMonitorGeneralViewController<Lullaby>?
    private let bag = DisposeBag()
    
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
    }
    
    func start() {
        showLullabies()
    }
    
    // MARK: - private functions
    private func showLullabies() {
        let viewModel = LullabiesViewModel(babyRepo: appDependencies.babyRepo)
        lullabiesViewController = BabyMonitorGeneralViewController(viewModel: AnyBabyMonitorGeneralViewModelProtocol<Lullaby>(viewModel: viewModel), type: .lullaby)
        lullabiesViewController?.rx.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.connect(toLullabiesViewModel: viewModel)
            })
            .disposed(by: bag)
        navigationController.pushViewController(lullabiesViewController!, animated: false)
    }
    
    private func connect(toLullabiesViewModel viewModel: LullabiesViewModel) {
        viewModel.showBabies?
            .subscribe(onNext: { [weak self] in
                guard let self = self, let lullabiesViewController = self.lullabiesViewController else {
                    return
                }
                self.toggleSwitchBabiesView(on: lullabiesViewController, babyRepo: self.appDependencies.babyRepo)
            })
            .disposed(by: bag)
    }
}
