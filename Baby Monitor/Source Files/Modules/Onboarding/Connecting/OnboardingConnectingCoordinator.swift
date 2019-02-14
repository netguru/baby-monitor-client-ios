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
        setupNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var appDependencies: AppDependencies
    var onEnding: (() -> Void)?
    var areAllRequiredPermissionsGranted: Bool {
        let isCameraAccessGranted = AVCaptureDevice.authorizationStatus(for: .video) == .authorized
        let isMicrophoneAccessGranted = AVCaptureDevice.authorizationStatus(for: .audio) == .authorized
        return isCameraAccessGranted && isMicrophoneAccessGranted
    }
    var areAllRequiredPermissionsNotDetermined: Bool {
        let isCameraAccessNotDetermined = AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined
        let isMicrophoneAccessNotDetermined = AVCaptureDevice.authorizationStatus(for: .audio) == .notDetermined
        return isCameraAccessNotDetermined || isMicrophoneAccessNotDetermined
    }
    
    private var isPermissionDenidedViewShown = false
    
    func start() {
        showContinuableView(role: .baby(.connectToWiFi))
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: .ApplicationDidBecomeActive, object: nil)
    }
    
    @objc
    private func applicationDidBecomeActive() {
        guard isPermissionDenidedViewShown else {
            return
        }
        if areAllRequiredPermissionsGranted {
            var currentViewControllers = navigationController.viewControllers
            currentViewControllers.removeLast()
            let putNextToBedViewController = prepareContinuableViewController(role: .baby(.putNextToBed))
            currentViewControllers.append(putNextToBedViewController)
            navigationController.setViewControllers(currentViewControllers, animated: true)
        }
    }
    
    private func connectTo(viewModel: OnboardingContinuableViewModel) {
        viewModel.cancelTap?.subscribe(onNext: { [weak self] in
            self?.navigationController.popViewController(animated: true)
        })
        .disposed(by: viewModel.bag)
        viewModel.nextButtonTap?.subscribe(onNext: { [weak self, weak viewModel] in
            guard let role = viewModel?.role else {
                return
            }
            switch role {
            case .baby(let babyRole):
                switch babyRole {
                case .connectToWiFi:
                    self?.showAccessView(role: .camera)
                case .putNextToBed:
                    self?.onEnding?()
                }
            }
        })
        .disposed(by: viewModel.bag)
    }
    
    private func showAccessView(role: OnboardingAccessViewModel.Role) {
        let viewModel = OnboardingAccessViewModel(role: role)
        let viewController = OnboardingAccessViewController(viewModel: viewModel)
        viewModel.accessObservable.subscribe(onNext: { [weak self] _ in
            guard let self = self else {
                return
            }
            switch role {
            case .camera:
                self.showAccessView(role: .microphone)
            case .microphone:
                if self.areAllRequiredPermissionsGranted {
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
        let viewModel = OnboardingTwoOptionsViewModel()
        let viewController = OnboardingTwoOptionsViewController(viewModel: viewModel)
        viewController.rx.viewDidLoad.subscribe(onNext: { [weak self] in
            self?.connect(to: viewModel)
        })
        .disposed(by: viewModel.bag)
        viewController.rx.viewWillDisappear.subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            self.isPermissionDenidedViewShown = false
        })
        .disposed(by: viewModel.bag)
        isPermissionDenidedViewShown = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationController.present(viewController, animated: true, completion: nil)
        }
    }
    
    private func connect(to viewModel: OnboardingTwoOptionsViewModel) {
        viewModel.upButtonTap?.subscribe(onNext: {
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(settingsUrl)
        })
        .disposed(by: viewModel.bag)
        viewModel.bottomButtonTap?.subscribe(onNext: { [weak self] in
            self?.showContinuableView(role: .baby(.putNextToBed))
        })
        .disposed(by: viewModel.bag)
    }
    
    private func showContinuableView(role: OnboardingContinuableViewModel.Role) {
        let viewController = prepareContinuableViewController(role: role)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func prepareContinuableViewController(role: OnboardingContinuableViewModel.Role) -> UIViewController {
        let viewModel = OnboardingContinuableViewModel(role: role)
        let viewController = OnboardingContinuableViewController(viewModel: viewModel)
        viewController.rx.viewDidLoad.subscribe(onNext: { [weak self] in
            self?.connectTo(viewModel: viewModel)
        })
        .disposed(by: viewModel.bag)
        return viewController
    }
    
    private func showSetupInformationView() {
        let viewModel = OldOnboardingContinuableViewModel()
        viewModel.onSelectNext = { [weak self] in
            self?.onEnding?()
        }
        let viewController = OldOnboardingContinuableViewController(role: .connecting(.setupInformation), viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
