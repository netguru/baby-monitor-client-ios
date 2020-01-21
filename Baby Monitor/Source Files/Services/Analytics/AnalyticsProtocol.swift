//
//  AnalyticsProtocol.swift
//  Baby Monitor

enum AnalyticsScreenType: String {
    case unrecognized
    case onboarding = "Onboarding"
    case specifyDeviceInfoOnboarding = "InfoAboutDevices"
    case specifyDevice = "SpecifyDevice"
    case recordingsIntroFeature = "VoiceRecordingsSetting"
    case connectToWiFi = "ConnectWifi"
    case cameraPermission = "PermissionCamera"
    case microphonePermission = "PermissionMicrophone"
    case permissionDenied = "PermissionDenied"
    case putNextToBed = "SetupInformation"
    case serverCamera = "ChildMonitor"
    case parentHello = "ParentDeviceInfo"
    case availableDevices = "ServiceDiscovery"
    case pairingCode = "Pairing"
    case connectionFailed = "ConnectionFailed" // TODO: Talk with Android and specify two cases
    case parentAllDone = "AllDone"
    case parentCameraPreview = "ClientLiveCamera"
    case parentDashboard = "ClientDashboard"
    case activityLog = "ClientActivityLog"
}

protocol AnalyticsProtocol {
    func logScreen(name: String, className: String)
}
