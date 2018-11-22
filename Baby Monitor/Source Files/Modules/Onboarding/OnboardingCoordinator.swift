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
    
    private var isAudioServiceErrorAlreadyShown = false
    
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
            babyRepo: appDependencies.babiesRepository)
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
        let viewModel = ServerViewModel(webRtcServerManager: appDependencies.webRtcServer(), messageServer: appDependencies.messageServer, netServiceServer: appDependencies.netServiceServer, decoders: appDependencies.webRtcMessageDecoders, cryingService: appDependencies.cryingEventService, babiesRepository: appDependencies.babiesRepository)
        let serverViewController = ServerViewController(viewModel: viewModel)
        viewModel.onCryingEventOccurence = { isBabyCrying in
            let title = isBabyCrying ? Localizable.Server.babyIsCrying : Localizable.Server.babyStoppedCrying
            AlertPresenter.showDefaultAlert(title: title, message: nil, onViewController: serverViewController)
        }
        viewModel.onAudioRecordServiceError = { [weak self] in
            guard let self = self,
                !self.isAudioServiceErrorAlreadyShown else {
                    return
            }
            self.isAudioServiceErrorAlreadyShown = true
            let message = Localizable.Server.audioRecordError
            AlertPresenter.showDefaultAlert(title: nil, message: message, onViewController: serverViewController)
        }
        navigationController.pushViewController(serverViewController, animated: true)
    }

    private func showDashboard() {
        onEnding?()
    }
}
