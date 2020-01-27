//
//  OnboardingConnectingCoordinator.swift
//  Baby Monitor
//

import Foundation
import UIKit
import AVFoundation

final class OnboardingConnectingCoordinator: Coordinator {
    
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
    }
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var appDependencies: AppDependencies
    var onEnding: (() -> Void)?
    
    private weak var connectToWiFiViewController: UIViewController?
    private var permissionsService: PermissionsProvider {
        return appDependencies.permissionsService
    }
    
    func start() {
        showContinuableView(role: .baby(.connectToWiFi))
    }
    
    private func connectTo(viewModel: OnboardingContinuableViewModel) {
        viewModel.cancelTap?.subscribe(onNext: { [weak self, weak viewModel] in
            guard let viewModel = viewModel else {
                return
            }
            switch viewModel.role {
            case .baby(.connectToWiFi):
                self?.navigationController.popViewController(animated: true)
            case .baby(.putNextToBed):
                guard let connectToWiFiViewController = self?.connectToWiFiViewController else {
                    return
                }
                self?.navigationController.popToViewController(connectToWiFiViewController, animated: true)
            case .parent:
                break
            }
        })
        .disposed(by: viewModel.bag)
        viewModel.nextButtonTap?.subscribe(onNext: { [weak self, weak viewModel] in
            guard let self = self, let role = viewModel?.role else {
                return
            }
            switch role {
            case .baby(let babyRole):
                switch babyRole {
                case .connectToWiFi:
                    if !self.permissionsService.isCameraAccessDecisionMade {
                        self.showAccessView(role: .camera)
                    } else if !self.permissionsService.isMicrophoneAccessDecisionMade {
                        self.showAccessView(role: .microphone)
                    } else if self.permissionsService.isCameraAndMicrophoneAccessGranted {
                        self.showContinuableView(role: .baby(.putNextToBed))
                    } else {
                        self.showPermissionsDeniedView()
                    }
                case .putNextToBed:
                    break
                }
            case .parent:
                break
            }
        })
        .disposed(by: viewModel.bag)
        viewModel.nextButtonTap?
            .filter { viewModel.role == .baby(.putNextToBed) }
            .take(1)
            .subscribe(onNext: { [weak self] in
                self?.onEnding?()
            })
        .disposed(by: viewModel.bag)
    }
    
    private func showAccessView(role: OnboardingAccessViewModel.Role) {
        let viewModel = OnboardingAccessViewModel(role: role, analytics: appDependencies.analytics)
        let viewController = OnboardingAccessViewController(viewModel: viewModel)
        viewModel.accessObservable.subscribe(onNext: { [weak self] _ in
            guard let self = self else {
                return
            }
            switch role {
            case .camera:
                if !self.permissionsService.isMicrophoneAccessDecisionMade {
                    self.showAccessView(role: .microphone)
                } else if self.permissionsService.isMicrophoneAccessGranted {
                    self.showContinuableView(role: .baby(.putNextToBed))
                } else {
                    self.showPermissionsDeniedView()
                }
            case .microphone:
                if self.permissionsService.isCameraAndMicrophoneAccessGranted {
                    self.showContinuableView(role: .baby(.putNextToBed))
                } else {
                    self.showPermissionsDeniedView()
                }
            }
        })
        .disposed(by: viewModel.bag)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showPermissionsDeniedView() {
        let viewModel = OnboardingTwoOptionsViewModel(permissionProvider: appDependencies.permissionsService,
                                                      analytics: appDependencies.analytics)
        let viewController = OnboardingTwoOptionsViewController(viewModel: viewModel)
        viewController.rx.viewDidLoad.subscribe(onNext: { [weak self] in
            self?.connect(to: viewModel)
        })
        .disposed(by: viewModel.bag)
        viewController.modalPresentationStyle = .fullScreen
        navigationController.present(viewController, animated: true, completion: nil)
    }
    
    private func connect(to viewModel: OnboardingTwoOptionsViewModel) {
        viewModel.upButtonTap?.subscribe(onNext: {
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(settingsUrl)
        })
        .disposed(by: viewModel.bag)
        viewModel.bottomButtonTap?.subscribe(onNext: { _ in
            exit(0)
        })
        .disposed(by: viewModel.bag)
    }
    
    private func showContinuableView(role: OnboardingContinuableViewModel.Role) {
        let viewController = prepareContinuableViewController(role: role)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func prepareContinuableViewController(role: OnboardingContinuableViewModel.Role) -> UIViewController {
        let viewModel = OnboardingContinuableViewModel(role: role, analytics: appDependencies.analytics)
        let viewController = OnboardingContinuableViewController(viewModel: viewModel)
        viewController.rx.viewDidLoad.subscribe(onNext: { [weak self] in
            self?.connectTo(viewModel: viewModel)
        })
        .disposed(by: viewModel.bag)
        if case .baby(.connectToWiFi) = role {
            connectToWiFiViewController = viewController
        }
        return viewController
    }
}
