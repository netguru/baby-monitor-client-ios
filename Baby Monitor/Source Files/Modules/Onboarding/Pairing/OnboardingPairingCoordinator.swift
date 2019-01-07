//
//  OnboardingPairingCoordinator.swift
//  Baby Monitor
//

import Foundation

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
        showInstallBMOnSecondDeviceView()
    }
    
    private func showInstallBMOnSecondDeviceView() {
        let viewModel = OnboardingContinuableViewModel()
        viewModel.onSelectNext = {
            self.showClientSetupView()
        }
        let viewController = OnboardingContinuableViewController(role: .pairing(.shareLink), viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showClientSetupView() {
        let viewModel = ClientSetupOnboardingViewModel(
            netServiceClient: appDependencies.netServiceClient(),
            urlConfiguration: appDependencies.urlConfiguration,
            babyRepo: appDependencies.babiesRepository,
            cacheService: appDependencies.cacheService,
            clientService: appDependencies.clientService)
        viewModel.didFinishDeviceSearch = { [weak self] result in
            switch result {
            case .success:
                self?.showPairingDoneView()
            case .failure:
                self?.showErrorPairingView()
            }
        }
        let viewController = OnboardingClientSetupViewController(role: .pairing(.pairing), viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showPairingDoneView() {
        let viewModel = OnboardingContinuableViewModel()
        viewModel.onSelectNext = {
            self.showAllDoneView()
        }
        let viewController = OnboardingContinuableViewController(role: .pairing(.pairingDone), viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showAllDoneView() {
        let viewModel = OnboardingContinuableViewModel()
        viewModel.onSelectNext = {
            self.onEnding?()
        }
        let viewController = OnboardingContinuableViewController(role: .pairing(.allDone), viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showErrorPairingView() {
        let viewModel = OnboardingContinuableViewModel()
        viewModel.onSelectNext = { [weak self] in
            self?.navigationController.dismiss(animated: true, completion: nil)
        }
        let viewController = OnboardingContinuableViewController(role: .pairing(.error), viewModel: viewModel)
        navigationController.present(viewController, animated: true, completion: nil)
    }
}
