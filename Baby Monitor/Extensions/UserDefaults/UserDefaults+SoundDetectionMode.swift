//
//  UserDefaults+SoundDetectionMode.swift
//  Baby Monitor

import Foundation

extension UserDefaults {

    private static var soundDetectionModeKey: String {
       return "VOICE_DETECTION_KEY"
    }

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
