//
//  UserDefaults+SoundDetectionMode.swift
//  Baby Monitor

import Foundation

extension UserDefaults {

    private static var soundDetectionModeKey: String {
       return "SOUND_DETECTION_KEY"
    }

    /// A current mode that is set in the app.
    static var soundDetectionMode: SoundDetectionMode {
        get {
            let rawValue = UserDefaults.standard.string(forKey: soundDetectionModeKey) ?? SoundDetectionMode.noiseDetection.rawValue
            return SoundDetectionMode(rawValue: rawValue)!
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: soundDetectionModeKey)
        }
    }
}
