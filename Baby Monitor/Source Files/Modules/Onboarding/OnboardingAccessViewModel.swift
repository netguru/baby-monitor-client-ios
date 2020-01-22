//
//  OnboardingAccessViewModel.swift
//  Baby Monitor
//

import Foundation
import AVFoundation
import RxSwift

final class OnboardingAccessViewModel: BaseViewModel {
    
    enum Role {
        case camera
        case microphone
    }
    
    let bag = DisposeBag()

    var analyticsScreenType: AnalyticsScreenType {
        switch role {
        case .camera: return .cameraPermission
        case .microphone: return .microphonePermission
        }
    }

    var title: String {
        switch role {
        case .camera, .microphone:
            return Localizable.Onboarding.connecting
        }
    }
    var description: String {
        switch role {
        case .camera:
            return Localizable.Onboarding.BabySetup.accessCameraMainDescription
        case .microphone:
            return Localizable.Onboarding.BabySetup.accessMicrophoneMainDescription
        }
    }
    var accessDescription: String {
        switch role {
        case .camera:
            return Localizable.Onboarding.BabySetup.accessCameraSecondDescription
        case .microphone:
            return Localizable.Onboarding.BabySetup.accessMicrophoneSecondDescription
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
    
    init(role: Role, analytics: AnalyticsManager) {
        self.role = role
        super.init(analytics: analytics)
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
                    DispatchQueue.main.async {
                        self.accessPublisher.onNext(())
                    }
                }
            }
        case .microphone:
            if AVCaptureDevice.authorizationStatus(for: .audio) != .notDetermined {
                accessPublisher.onNext(())
            } else {
                AVCaptureDevice.requestAccess(for: .audio) { _ in
                    DispatchQueue.main.async {
                        self.accessPublisher.onNext(())
                    }
                }
            }
        }
    }
}
