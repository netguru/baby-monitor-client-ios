//
//  AnalyticsScreenType.swift
//  Baby Monitor

enum AnalyticsScreenType: String {
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
    case deviceSearchingFailed = "DeviceSearchingFailed"
    case pairingFailed = "PairingFailed"
    case parentAllDone = "AllDone"
    case parentCameraPreview = "ClientLiveCamera"
    case parentDashboard = "ClientDashboard"
    case activityLog = "ClientActivityLog"
    case babySettings = "ChildSettings"
    case parentSettings = "ParentSettings"
}
