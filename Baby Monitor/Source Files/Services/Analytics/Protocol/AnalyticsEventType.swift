//
//  AnalyticsEventType.swift
//  Baby Monitor

import Foundation

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
