//
//  AnalyticsProtocol.swift
//  Baby Monitor

import Foundation

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
    case deviceSearchingFailed = "DeviceSearchingFailed"
    case pairingFailed = "PairingFailed"
    case parentAllDone = "AllDone"
    case parentCameraPreview = "ClientLiveCamera"
    case parentDashboard = "ClientDashboard"
    case activityLog = "ClientActivityLog"
    case babySettings = "ChildSettings"
    case parentSettings = "ParentSettings"
}

enum AnalyticsEventType {
    case notificationSent
    case resetApp
    case rateUs
    case nightMode(isEnabled: Bool)
    case videoStreamConnected
    case videoStreamError

    var eventName: String {
        switch self {
        case .notificationSent: return "notification_sent"
        case .resetApp: return "reset_app"
        case .rateUs: return "rate_us"
        case .nightMode: return "night_mode"
        case .videoStreamConnected: return "video_stream_connected"
        case .videoStreamError: return  "video_stream_error"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .resetApp:
            return ["caller": UserDefaults.appMode.rawValue]
        case .nightMode(let isEnabled):
            return ["is_enabled": isEnabled]
        case .notificationSent:
            return ["type": "cry_notification"]
        case .rateUs, .videoStreamConnected, .videoStreamError:
            return nil
        }
    }

}

protocol AnalyticsProtocol {
    func logScreen(name: String, className: String)
    func logEvent(_ eventName: String, parameters: [String: Any]?)
}
