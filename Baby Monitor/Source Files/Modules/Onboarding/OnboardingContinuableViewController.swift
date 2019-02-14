//
//  OnboardingContinuableViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import AVFoundation

final class OnboardingContinuableViewController: TypedViewController<ContinuableBaseOnboardingView> {
    
    private let viewModel: OnboardingContinuableViewModel
    
    init(viewModel: OnboardingContinuableViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: ContinuableBaseOnboardingView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        navigationItem.leftBarButtonItem = customView.cancelButtonItem
        customView.update(title: viewModel.title)
        customView.update(mainDescription: viewModel.description)
        customView.update(image: viewModel.image)
        customView.update(buttonTitle: viewModel.buttonTitle)
        viewModel.attachInput(
            buttonTap: customView.rx.buttonTap.asObservable(),
            cancelButtonTap: customView.rx.cancelButtonTap.asObservable())
    }
}

final class OnboardingContinuableViewModel {
    
    enum Role {
        case baby(BabyRole)
    }
    
    enum BabyRole {
        case connectToWiFi
        case putNextToBed
    }
    
    
    let role: Role
    let bag = DisposeBag()
    var title: String {
        switch role {
        case .baby(let babyRole):
            switch babyRole {
            case .connectToWiFi:
                return Localizable.Onboarding.connecting
            case .putNextToBed:
                return Localizable.Onboarding.Connecting.setupInformation
            }
        }
    }
    var description: String {
        switch role {
        case .baby(let babyRole):
            switch babyRole {
            case .connectToWiFi:
                return Localizable.Onboarding.Connecting.connectToWiFi
            case .putNextToBed:
                return Localizable.Onboarding.Connecting.placeDevice
            }
        }
    }
    var buttonTitle: String {
        switch role {
        case .baby(let babyRole):
            switch babyRole {
            case .connectToWiFi:
                return Localizable.Onboarding.Connecting.connectToWiFiButtonTitle
            case .putNextToBed:
                return Localizable.Onboarding.Connecting.startMonitoring
            }
        }
    }
    var image: UIImage {
        switch role {
        case .baby(let babyRole):
            switch babyRole {
            case .connectToWiFi:
                return #imageLiteral(resourceName: "onboarding-connecting")
            case .putNextToBed:
                return #imageLiteral(resourceName: "onboarding-camera")
            }
        }
    }
    var cancelTap: Observable<Void>?
    var nextButtonTap: Observable<Void>?
    
    init(role: Role) {
        self.role = role
    }
    
    func attachInput(buttonTap: Observable<Void>, cancelButtonTap: Observable<Void>) {
        cancelTap = cancelButtonTap
        nextButtonTap = buttonTap
    }
}

final class OnboardingAccessViewController: TypedViewController<AccessBaseOnboardingView> {
    
    private let viewModel: OnboardingAccessViewModel
    
    init(viewModel: OnboardingAccessViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: AccessBaseOnboardingView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.checkAccess()
    }
    
    private func setup() {
        customView.update(title: viewModel.title)
        customView.update(mainDescription: viewModel.description)
        customView.update(image: viewModel.image)
        customView.update(accessDescription: viewModel.accessDescription)
    }
}

final class OnboardingAccessViewModel {
    
    enum Role {
        case camera
        case microphone
    }
    
    let bag = DisposeBag()
    var title: String {
        switch role {
        case .camera, .microphone:
            return Localizable.Onboarding.connecting
        }
    }
    var description: String {
        switch role {
        case .camera:
            return "Tap “OK” to keep an\neye on your baby!"
        case .microphone:
            return "Tap “OK” if you want\nto know if your baby\nis crying"
        }
    }
    var accessDescription: String {
        switch role {
        case .camera:
            return "Don't worry - we care about your safety. No video\nwill be recorded and we will protect you from any\ndata leakage."
        case .microphone:
            return "Don't worry - we care about your safety. Voice will\nonly be recorded with your permission, and will only\nbe used to let you know if your baby is crying."
        }
    }
    var image: UIImage {
        switch role {
        case .camera, .microphone:
            return #imageLiteral(resourceName: "onboarding-safety")
        }
    }
    lazy var accessObservable = accessPublisher.asObservable()
    
    private var accessPublisher = PublishSubject<Void>()
    private let role: Role
    
    init(role: Role) {
        self.role = role
    }
    
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
    
    func checkAccess() {
        switch role {
        case .camera:
            if AVCaptureDevice.authorizationStatus(for: .video) != .notDetermined {
                accessPublisher.onNext(())
            } else {
                AVCaptureDevice.requestAccess(for: .video) { _ in
                    self.accessPublisher.onNext(())
                }
            }
        case .microphone:
            if AVCaptureDevice.authorizationStatus(for: .audio) != .notDetermined {
                accessPublisher.onNext(())
            } else {
                AVCaptureDevice.requestAccess(for: .audio) { _ in
                    self.accessPublisher.onNext(())
                }
            }
        }
    }
}

final class OnboardingTwoOptionsViewController: TypedViewController<TwoOptionsBaseOnboardingView> {
    
    private let viewModel: OnboardingTwoOptionsViewModel
    
    init(viewModel: OnboardingTwoOptionsViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: TwoOptionsBaseOnboardingView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        customView.update(title: viewModel.title)
        customView.update(mainDescription: viewModel.mainDescription)
        customView.update(secondaryDescription: viewModel.secondaryDescription)
        customView.update(image: viewModel.image)
        customView.update(upButtonTitle: viewModel.upButtonTitle)
        customView.update(bottomButtonTitle: viewModel.bottomButtonTitle)
        viewModel.attachInput(
            upButtonTap: customView.rx.upButtonTap.asObservable(),
            bottomButtonTap: customView.rx.bottomButtonTap.asObservable())
    }
}

final class OnboardingTwoOptionsViewModel {
    var upButtonTap: Observable<Void>?
    var bottomButtonTap: Observable<Void>?
    let bag = DisposeBag()
    let title = "Permissions denied"
    let image = #imageLiteral(resourceName: "onboarding-error")
    let mainDescription = "Baby Monitor is\nunable to work\nwithout permissions."
    let secondaryDescription = "Are you sure you want to deny\npermissions?"
    let upButtonTitle = "Retry"
    let bottomButtonTitle = "I'm sure"
    
    func attachInput(upButtonTap: Observable<Void>, bottomButtonTap: Observable<Void>) {
        self.upButtonTap = upButtonTap
        self.bottomButtonTap = bottomButtonTap
    }
}
