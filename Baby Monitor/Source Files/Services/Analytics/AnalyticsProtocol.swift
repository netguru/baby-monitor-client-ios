//
//  AnalyticsProtocol.swift
//  Baby Monitor

enum AnalyticsScreenType: String {
    case onboarding = "Onboarding"
    case specifyDeviceInfoOnboarding = "InfoAboutDevices"
    case specifyDevice = "SpecifyDevice"
    case recordingsIntroFeature = "VoiceRecordingsSetting"
//    ConnectWifi
//    PermissionCamera
//    PermissionMicrophone
//    PermissionDenied
//    SetupInformation
//    ChildMonitor
//    ParentDeviceInfo
//    ServiceDiscovery
//    Pairing
//    ConnectionFailed
//    AllDone
//    ClientLiveCamera
//    ClientDashboard
//    ClientActivityLog

}

protocol AnalyticsProtocol {
    func logScreen(name: String, className: String)
}
