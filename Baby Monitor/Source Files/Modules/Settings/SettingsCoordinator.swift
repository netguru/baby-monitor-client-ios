//
//  SettingsCoordinator.swift
//  Baby Monitor
//

import UIKit
import RxSwift

final class SettingsCoordinator: Coordinator, BabiesViewShowable {
    
    var appDependencies: AppDependencies
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var switchBabyViewController: BabyMonitorGeneralViewController<SwitchBabyViewModel.Cell>?
    var onEnding: (() -> Void)?
    
    private let bag = DisposeBag()
    private weak var settingsViewController: BabyMonitorGeneralViewController<SettingsViewModel.Cell>?
    
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.appDependencies = appDependencies
        self.navigationController = navigationController
    }
    
    func start() {
        showSettings()
    }
    
    // MARK: - private functions
    private func showSettings() {
        let viewModel = SettingsViewModel(babyRepo: appDependencies.babyRepo)

        let settingsViewController = BabyMonitorGeneralViewController(viewModel: AnyBabyMonitorGeneralViewModelProtocol<SettingsViewModel.Cell>(viewModel: viewModel), type: .settings)
        settingsViewController.rx.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.connect(toSettingsViewModel: viewModel)
            })
            .disposed(by: bag)
        self.settingsViewController = settingsViewController
        navigationController.pushViewController(settingsViewController, animated: false)
    }
    
    private func connect(toSettingsViewModel viewModel: SettingsViewModel) {
        viewModel.showBabies?
            .subscribe(onNext: { [weak self] in
                guard let self = self, let settingsViewController = self.settingsViewController else {
                    return
                }
                self.toggleSwitchBabiesView(on: settingsViewController, babyRepo: self.appDependencies.babyRepo)
            })
            .disposed(by: bag)
        viewModel.didSelectChangeServer = { [weak self] in
            self?.showClientSetup()
        }
    }
    
    private func showClientSetup() {
        let clientSetupViewModel = ClientSetupOnboardingViewModel(
            netServiceClient: appDependencies.netServiceClient,
            urlConfiguration: appDependencies.urlConfiguration,
            babyRepo: appDependencies.babyRepo)
        
        let clientSetupViewController = GeneralOnboardingViewController(viewModel: clientSetupViewModel, role: .clientSetup)
        clientSetupViewController.rx.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.connect(toClientSetupViewModel: clientSetupViewModel)
            })
            .disposed(by: bag)
        
        navigationController.pushViewController(clientSetupViewController, animated: true)
    }
    
    private func connect(toClientSetupViewModel viewModel: ClientSetupOnboardingViewModel) {
        viewModel.didFinishDeviceSearch = { [weak self] result in
            switch result {
            case .success:
                _ = self?.navigationController.popViewController(animated: true)
            case .failure:
                self?.appDependencies.errorHandler.showAlert(
                    title: Localizable.Errors.errorOccured,
                    message: Localizable.Errors.unableToFind,
                    presenter: self?.navigationController
                )
            }
        }
    }
}
