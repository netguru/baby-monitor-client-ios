//
//  PermissionsProvider.swift
//  Baby Monitor

/// Permission which user had denied to give to the app.
enum DeniedPermissions {
    case onlyCamera, onlyMicrophone, cameraAndMicrophone, none
}

//// Provides the information to the permissions which user was asked.
protocol PermissionsProvider {

    /// Identifies whether the user already responded to the question about granting a camera permission.
    var isCameraAccessDecisionMade: Bool { get }

    /// Identifies whether the user already responded to the question about granting a microphone permission.
    var isMicrophoneAccessDecisionMade: Bool { get }

    /// Identifies whether the user gave a camera permission.
    var isCameraAccessGranted: Bool { get }

    /// Identifies whether the user gave a microphone permission.
    var isMicrophoneAccessGranted: Bool { get }

    /// Identifies whether the user gave a camera and microphone  permission.
    var isCameraAndMicrophoneAccessGranted: Bool { get }

    /// Permissions which the user had denied for the app.
    var deniedPermissions: DeniedPermissions { get }
}
