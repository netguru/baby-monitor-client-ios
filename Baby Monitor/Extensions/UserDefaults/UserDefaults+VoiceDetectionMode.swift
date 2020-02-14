//
//  UserDefaults+VoiceDetectionMode.swift
//  Baby Monitor

import Foundation

extension UserDefaults {

    private static var voiceDetectionModeKey: String {
       return "VOICE_DETECTION_KEY"
    }

    static var voiceDetectionMode: VoiceDetectionMode {
        get {
            let rawValue = UserDefaults.standard.string(forKey: voiceDetectionModeKey) ?? VoiceDetectionMode.noiseDetection.rawValue
            return VoiceDetectionMode(rawValue: rawValue)!
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: voiceDetectionModeKey)
        }
    }
}
