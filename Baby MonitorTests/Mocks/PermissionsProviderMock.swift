//
//  PermissionsProviderMock.swift
//  Baby MonitorTests

import Foundation
@testable import BabyMonitor

final class PermissionsProviderMock: PermissionsProvider {
    var isCameraAccessDecisionMade: Bool = false

    var isMicrophoneAccessDecisionMade: Bool = false

    var isCameraAccessGranted: Bool = false

    var isMicrophoneAccessGranted: Bool = false

    var isCameraAndMicrophoneAccessGranted: Bool = false

    var deniedPermissions: DeniedPermissions = .none
}
