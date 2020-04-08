//
//  ServerCoordinator.swift
//  Baby Monitor
//

import Foundation
import RxSwift

final class ServerCoordinator: Coordinator {
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
        setupParentSettingsCoordinator()
    }
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var appDependencies: AppDependencies
    var onEnding: (() -> Void)?
    
    private weak var parentSettingsCoordinator: SettingsCoordinator?
    private var isAudioServiceErrorAlreadyShown = false
    private let bag = DisposeBag()
    
    func start() {
        setupBindings()
        showServerView()
    }
    
    private func setupBindings() {
        appDependencies.applicationResetter.localResetCompletionObservable
            .subscribe(onNext: { [weak self] resetCompleted in
                self?.onEnding?()
            })
            .disposed(by: bag)
        appDependencies.serverService.remoteParingCodeObservable
            .subscribe(onNext: { [weak self] code in
                guard !code.isEmpty else {
                    self?.navigationController.dismiss(animated: true, completion: nil)
                    return
                }
                self?.showCodeAlert(with: code)
            })
            .disposed(by: bag)
    }
    
    private func showServerView() {
        let viewModel = ServerViewModel(serverService: appDependencies.serverService,
                                        permissionsProvider: appDependencies.permissionsService,
                                        analytics: appDependencies.analytics)
        let serverViewController = ServerViewController(viewModel: viewModel)
        viewModel.onAudioMicrophoneServiceError = { [unowned self, weak serverViewController] in
            guard
                !self.isAudioServiceErrorAlreadyShown,
                let serverViewController = serverViewController
            else {
                return
            }
            self.isAudioServiceErrorAlreadyShown = true
            let message = Localizable.Server.audioRecordError
            AlertPresenter.showDefaultAlert(title: nil, message: message, onViewController: serverViewController)
        }
        viewModel.settingsTap?.subscribe(onNext: { [unowned self] in
            self.parentSettingsCoordinator?.start()
        })
        .disposed(by: viewModel.bag)
        self.navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.setViewControllers([serverViewController], animated: true)
    }
    
    private func setupParentSettingsCoordinator() {
        let parentSettingsCoordinator = SettingsCoordinator(navigationController, appDependencies: appDependencies)
        childCoordinators.append(parentSettingsCoordinator)
        parentSettingsCoordinator.onEnding = { [unowned self] in
            switch UserDefaults.appMode {
            case .none:
                self.onEnding?()
            case .baby:
                if let coordinator = self.parentSettingsCoordinator {
                    self.remove(coordinator)
                }
                self.setupParentSettingsCoordinator()
            case .parent:
                break
            }
        }
        self.parentSettingsCoordinator = parentSettingsCoordinator
    }

    private func showCodeAlert(with code: String) {
        let declineAction = UIAlertAction(title: Localizable.General.decline, style: .default, handler: { [weak self] _ in
            self?.appDependencies.messageServer.send(message: EventMessage(pairingCodeResponse: false).toStringMessage())

        })
        let acceptAction = UIAlertAction(title: Localizable.General.accept, style: .default, handler: { [weak self] _ in
            self?.appDependencies.messageServer.send(message: EventMessage(pairingCodeResponse: true).toStringMessage())
            self?.appDependencies.netServiceServer.isEnabled.accept(false)

        })
        let codeAlertController = UIAlertController(title: Localizable.Onboarding.Pairing.connection, message: Localizable.Onboarding.Pairing.connectionAlertInfo(code: code), preferredStyle: .alert)
        [declineAction, acceptAction].forEach { codeAlertController.addAction($0) }
        codeAlertController.preferredAction = acceptAction
        navigationController.present(codeAlertController, animated: true, completion: nil)
    }
}
