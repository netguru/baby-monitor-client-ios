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
    }

    private func showInitialSetup() {
        let viewModel = SpecifyDeviceOnboardingViewModel()
        viewModel.didSelectBaby = { [weak self] in
            self?.showConnectToWiFiView()
        }
        viewModel.didSelectParent = { [weak self] in
            self?.pairingCoordinator?.start()
        }
        let viewController = SpecifyDeviceOnboardingViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showConnectToWiFiView() {
        let viewModel = OnboardingContinuableViewModel()
        viewModel.onSelectNext = { [weak self] in
           self?.showServerView()
        }
        let viewController = OnboardingContinuableViewController(role: .connecting, viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showServerView() {
        let viewModel = ServerViewModel(webRtcServerManager: appDependencies.webRtcServer(appDependencies.peerConnection(), appDependencies.webRtcStreamFactory), messageServer: appDependencies.messageServer, netServiceServer: appDependencies.netServiceServer, decoders: appDependencies.webRtcMessageDecoders, cryingService: appDependencies.cryingEventService, babiesRepository: appDependencies.babiesRepository)
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
}
