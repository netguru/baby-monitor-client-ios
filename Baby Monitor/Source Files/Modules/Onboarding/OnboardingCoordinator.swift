//
//  OnboardingCoordinator.swift
//  Baby Monitor
//

import UIKit

final class OnboardingCoordinator: Coordinator {

    var appDependencies: AppDependencies
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var onEnding: (() -> Void)?
    
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
    }

    func start() {
        showInitialSetup()
    }

    private func showInitialSetup() {
        let viewModel = InitialOnboardingViewModel()
        viewModel.didSelectBabyMonitorServer = { [weak self] in
            self?.showServerView()
        }
        viewModel.didSelectBabyMonitorClient = { [weak self] in
            self?.showStartDiscoveringView()
        }
        let viewController = GeneralOnboardingViewController(viewModel: viewModel, role: .begin)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showStartDiscoveringView() {
        let viewModel = StartDiscoveringOnboardingViewModel()
        viewModel.didSelectStartDiscovering = { [weak self] in
            self?.showClientSetup()
        }
        let viewController = GeneralOnboardingViewController(viewModel: viewModel, role: .startDiscovering)
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showClientSetup() {
        let viewModel = ClientSetupOnboardingViewModel(
            netServiceClient: appDependencies.netServiceClient,
            rtspConfiguration: appDependencies.rtspConfiguration,
            babyRepo: appDependencies.babyRepo)
        viewModel.didFinishDeviceSearch = { [weak self] result in
            switch result {
            case .success:
                self?.showDashboard()
            case .failure:
                self?.appDependencies.errorHandler.showAlert(
                    title: Localizable.Errors.errorOccured,
                    message: Localizable.Errors.unableToFind,
                    presenter: self?.navigationController
                )
            }
        }
        let viewController = GeneralOnboardingViewController(viewModel: viewModel, role: .clientSetup)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showServerView() {
        let viewModel = ServerViewModel(mediaPlayerStreamingService: appDependencies.mediaPlayerStreamingService)
        navigationController.pushViewController(ServerViewController(viewModel: viewModel), animated: true)
    }

    private func showDashboard() {
        onEnding?()
    }
}
