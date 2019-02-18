//
//  OnboardingPairingCoordinator.swift
//  Baby Monitor
//

import Foundation
import UIKit

final class OnboardingPairingCoordinator: Coordinator {
    
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
    }
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var appDependencies: AppDependencies
    var onEnding: (() -> Void)?
    
    func start() {
        switch UserDefaults.appMode {
        case .none:
            showInstallBMOnSecondDeviceView()
        case .parent:
            showClientSetupView()
        case .baby:
            break
        }
    }
    
    private func showInstallBMOnSecondDeviceView() {
        let viewModel = OldOnboardingContinuableViewModel()
        viewModel.onSelectNext = {
            self.showClientSetupView()
        }
        let viewController = OldOnboardingContinuableViewController(role: .pairing(.shareLink), viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showClientSetupView() {
        let viewModel = ClientSetupOnboardingViewModel(
            netServiceClient: appDependencies.netServiceClient(),
            urlConfiguration: appDependencies.urlConfiguration,
            activityLogEventsRepository: appDependencies.databaseRepository,
            cacheService: appDependencies.cacheService,
            webSocketEventMessageService: appDependencies.webSocketEventMessageService)
        viewModel.didFinishDeviceSearch = { [weak self] result in
            switch result {
            case .success:
                switch UserDefaults.appMode {
                case .parent:
                    self?.onEnding?()
                case .none:
                    self?.showPairingDoneView()
                case .baby:
                    break
                }
            case .failure:
                self?.showErrorPairingView()
            }
        }
        let viewController = OnboardingClientSetupViewController(role: .pairing(.pairing), viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showPairingDoneView() {
        let viewModel = OldOnboardingContinuableViewModel()
        viewModel.onSelectNext = {
            self.showAllDoneView()
        }
        let viewController = OldOnboardingContinuableViewController(role: .pairing(.pairingDone), viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showAllDoneView() {
        let viewModel = OldOnboardingContinuableViewModel()
        viewModel.onSelectNext = {
            self.onEnding?()
        }
        let viewController = OldOnboardingContinuableViewController(role: .pairing(.allDone), viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showErrorPairingView() {
        let viewModel = OldOnboardingContinuableViewModel()
        viewModel.onSelectNext = { [weak self] in
            self?.navigationController.dismiss(animated: true, completion: nil)
        }
        let viewController = OldOnboardingContinuableViewController(role: .pairing(.error), viewModel: viewModel)
        navigationController.present(viewController, animated: true, completion: nil)
    }
}
