//
//  AnalyticsPropertyType.swift
//  Baby Monitor


import Foundation

/// The custom user properties to be logged in to analytics service.
enum AnalyticsPropertyType {

    /// The app state type.
    enum AppStateType: String {
        /// Undefined - after onboarding when user didn’t specify the device.
        case undefined
        /// Server - user set up the device as baby.
        case server
        /// Client - use set up the device as parent.
        case client
        /// First open - user opened the app and didn’t finish the onboarding yet.
        case firstOpen = "first_open"
    }
    case soundMode(SoundDetectionMode)
    case appState(AppStateType)
    case noiseLevel(Int)

    /// The value of the property.
    var name: String {
        switch self {
        case .soundMode: return "voice_analysis"
        case .appState: return "app_state"
        case .noiseLevel: return "noise_level"
        }
    }

    /// The key name of the property.
    var value: String? {
        switch self {
        case .soundMode(let mode):
            switch mode {
            case .noiseDetection: return "noise_detection"
            case .cryRecognition: return "machine_learning"
            }
        case .appState(let state):
            return state.rawValue
        case .noiseLevel(let value):
            return String(value)
        }
    }

}
