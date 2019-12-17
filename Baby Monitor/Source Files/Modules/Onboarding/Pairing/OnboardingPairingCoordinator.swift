//
//  OnboardingPairingCoordinator.swift
//  Baby Monitor
//

import Foundation
import UIKit
import RxSwift

final class OnboardingPairingCoordinator: Coordinator {
    
    private let disposeBag = DisposeBag()
    
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
            showContinuableView(role: .parent(.hello))
        case .parent:
            showPairingView()
        case .baby:
            break
        }
        setupRemoteResetHandling()
    }
}

private extension OnboardingPairingCoordinator {
    
    func setupRemoteResetHandling() {
        appDependencies.applicationResetter.localResetCompletionObservable
            .subscribe(onNext: { [weak self] resetCompleted in
                UserDefaults.appMode = .none
                self?.navigationController.popToRootViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    
    func showContinuableView(role: OnboardingContinuableViewModel.Role) {
        let continuableViewController = prepareContinuableViewController(role: role)
        switch role {
        case .parent(.error):
            continuableViewController.modalPresentationStyle = .fullScreen
            navigationController.present(continuableViewController, animated: true)
        default:
            navigationController.pushViewController(continuableViewController, animated: true)
        }
    }
    
    func prepareContinuableViewController(role: OnboardingContinuableViewModel.Role) -> UIViewController {
        let viewModel = OnboardingContinuableViewModel(role: role)
        let viewController = OnboardingContinuableViewController(viewModel: viewModel)
        viewController.rx.viewDidLoad.subscribe(onNext: { [weak self] in
            self?.connectTo(viewModel: viewModel)
        }).disposed(by: viewModel.bag)
        return viewController
    }
    
    func connectTo(viewModel: OnboardingContinuableViewModel) {
        viewModel.cancelTap?.subscribe(onNext: { [weak self] in
            self?.navigationController.popViewController(animated: true)
        })
        .disposed(by: viewModel.bag)
        viewModel.nextButtonTap?.subscribe(onNext: { [weak self, weak viewModel] in
                guard let role = viewModel?.role else {
                    return
                }
                switch role {
                case .parent(let parentRole):
                    switch parentRole {
                    case .hello:
                        self?.showPairingView()
                    case .error:
                        self?.navigationController.presentedViewController?.dismiss(animated: true)
                    case .allDone:
                        break
                    }
                case .baby:
                    break
                }
            })
            .disposed(by: viewModel.bag)
        viewModel.nextButtonTap?
            .filter {
                viewModel.role == .parent(.allDone)
            }
            .take(1)
            .subscribe(onNext: { [weak self] in
                self?.onEnding?()
            })
            .disposed(by: viewModel.bag)
    }
    
    func connect(to viewModel: ClientSetupOnboardingViewModel) {
        viewModel.cancelTap?.subscribe(onNext: { [unowned self] in
            self.navigationController.popViewController(animated: true)
        })
        .disposed(by: viewModel.bag)
    }
    
    func showPairingView() {
        let viewModel = ClientSetupOnboardingViewModel(
            netServiceClient: appDependencies.netServiceClient,
            urlConfiguration: appDependencies.urlConfiguration,
            activityLogEventsRepository: appDependencies.databaseRepository,
            webSocketEventMessageService: appDependencies.webSocketEventMessageService.get(),
            serverErrorLogger: appDependencies.serverErrorLogger)
        viewModel.didFinishDeviceSearch = { [weak self] result in
            switch result {
            case .success:
                switch UserDefaults.appMode {
                case .parent:
                    self?.onEnding?()
                case .none:
//                    self?.showCompareCodeView()
                    self?.navigationController.dismiss(animated: true)
                    self?.showContinuableView(role: .parent(.allDone))
                case .baby:
                    break
                }
            case .failure:
                self?.showContinuableView(role: .parent(.error))
            }
        }
        let viewController = OnboardingClientSetupViewController(viewModel: viewModel)
        viewController.rx.viewDidLoad.subscribe(onNext: { [weak self] in
            self?.connect(to: viewModel)
        })
        .disposed(by: viewModel.bag)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showCompareCodeView() {
//        let viewController = OnboardingCompareCodeViewController(viewModel: OnboardingCompareCodeViewModel())
//        navigationController.pushViewController(viewController, animated: true)
    }
}
