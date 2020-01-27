//
//  PermissionsService.swift
//  Baby Monitor

import AVFoundation

//// Provides the information to the permissions which user was asked.
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
