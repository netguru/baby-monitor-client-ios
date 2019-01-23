//
//  ServerCoordinator.swift
//  Baby Monitor
//

import Foundation

final class ServerCoordinator: Coordinator {
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
    }
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var appDependencies: AppDependencies
    var onEnding: (() -> Void)?
    
    private var isAudioServiceErrorAlreadyShown = false
    
    func start() {
        showServerView()
    }
    
    private func showServerView() {
        let viewModel = ServerViewModel(serverService: appDependencies.serverService)
        let serverViewController = ServerViewController(viewModel: viewModel)
        viewModel.onAudioRecordServiceError = { [unowned self] in
            guard !self.isAudioServiceErrorAlreadyShown else {
                    return
            }
            self.isAudioServiceErrorAlreadyShown = true
            let message = Localizable.Server.audioRecordError
            AlertPresenter.showDefaultAlert(title: nil, message: message, onViewController: serverViewController)
        }
        navigationController.pushViewController(serverViewController, animated: true)
    }
}
