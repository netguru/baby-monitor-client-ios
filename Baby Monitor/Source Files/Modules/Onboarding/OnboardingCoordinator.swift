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
    private weak var pairingCoordinator: OnboardingPairingCoordinator?
    private weak var connectingCoordinator: OnboardingConnectingCoordinator?
    
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
        setup()
    }

    func start() {
        childCoordinators.first?.start()
    }
    
    private func setup() {
        let introCoordinator = IntroCoordinator(navigationController, appDependencies: appDependencies)
        childCoordinators.append(introCoordinator)
        introCoordinator.onEnding = { [weak self] in
            self?.showInitialSetup()
        }
        navigationController.setNavigationBarHidden(true, animated: false)
        let pairingCoordinator = OnboardingPairingCoordinator(navigationController, appDependencies: appDependencies)
        pairingCoordinator.onEnding = { [weak self] in
            self?.onEnding?()
        }
        childCoordinators.append(pairingCoordinator)
        self.pairingCoordinator = pairingCoordinator
        let connectingCoordinator = OnboardingConnectingCoordinator(navigationController, appDependencies: appDependencies)
        connectingCoordinator.onEnding = { [weak self] in
            self?.showServerView()
        }
        childCoordinators.append(connectingCoordinator)
        self.connectingCoordinator = connectingCoordinator
    }

    private func showInitialSetup() {
        let viewModel = SpecifyDeviceOnboardingViewModel()
        viewModel.didSelectBaby = { [weak self] in
            self?.connectingCoordinator?.start()
        }
        viewModel.didSelectParent = { [weak self] in
            self?.pairingCoordinator?.start()
        }
        let viewController = SpecifyDeviceOnboardingViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showServerView() {
        let viewModel = ServerViewModel(webRtcServerManager: appDependencies.webRtcServer(), messageServer: appDependencies.messageServer, netServiceServer: appDependencies.netServiceServer, decoders: appDependencies.webRtcMessageDecoders, cryingService: appDependencies.cryingEventService, babiesRepository: appDependencies.babiesRepository)
        let serverViewController = ServerViewController(viewModel: viewModel)
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
}
