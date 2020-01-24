//
//  PermissionsProvider.swift
//  Baby Monitor

import AVFoundation

enum DeniedPermissions {
    case onlyCamera, onlyMicrophone, cameraAndMicrophone, none
}

protocol PermissionsProvider {
    var isCameraAccessDecisionMade: Bool { get }
    var isMicrophoneAccessDecisionMade: Bool { get }
    var isCameraAccessGranted: Bool { get }
    var isMicrophoneAccessGranted: Bool { get }
    var isCameraAndMicrophoneAccessGranted: Bool { get }
    var deniedPermissions: DeniedPermissions { get }
}

final class PermissionsService: PermissionsProvider {

    var isCameraAccessDecisionMade: Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) != .notDetermined
    }

    var isMicrophoneAccessDecisionMade: Bool {
        return AVCaptureDevice.authorizationStatus(for: .audio) != .notDetermined
    }

    var isCameraAccessGranted: Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }

    var isMicrophoneAccessGranted: Bool {
        return AVCaptureDevice.authorizationStatus(for: .audio) == .authorized
    }

    var isCameraAndMicrophoneAccessGranted: Bool {
        return isCameraAccessGranted && isMicrophoneAccessGranted
    }

    var deniedPermissions: DeniedPermissions {
        if isCameraAndMicrophoneAccessGranted {
            return .none
        } else if isCameraAccessGranted && !isMicrophoneAccessGranted {
            return .onlyMicrophone
        } else if !isCameraAccessGranted && isMicrophoneAccessGranted {
            return .onlyCamera
        } else {
            return .cameraAndMicrophone
        }
    }
}
