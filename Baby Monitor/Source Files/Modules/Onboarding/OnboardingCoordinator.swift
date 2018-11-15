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
            urlConfiguration: appDependencies.urlConfiguration,
            babyRepo: appDependencies.babyRepo)
        viewModel.didFinishDeviceSearch = { [weak self] result in
            switch result {
            case .success:
                self?.showDashboard()
            case .failure:
                // TODO: add error handling
                break
            }
        }
        let viewController = GeneralOnboardingViewController(viewModel: viewModel, role: .clientSetup)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showServerView() {
        let viewModel = ServerViewModel(webRtcServerManager: appDependencies.webRtcServer, messageServer: appDependencies.messageServer, netServiceServer: appDependencies.netServiceServer, decoders: appDependencies.webRtcMessageDecoders)
        navigationController.pushViewController(ServerViewController(viewModel: viewModel), animated: true)
    }

    private func showDashboard() {
        onEnding?()
    }
}
