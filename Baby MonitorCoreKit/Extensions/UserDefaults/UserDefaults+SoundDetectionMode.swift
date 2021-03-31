//
//  UserDefaults+SoundDetectionMode.swift
//  Baby Monitor

import Foundation

extension UserDefaults {

    private static var soundDetectionModeKey: String {
       return "SOUND_DETECTION_KEY"
    }

    private static var noiseLevelKey: String {
       return "NOISE_LEVEL_KEY"
    }

    /// A current mode that is set in the app.
    static var soundDetectionMode: SoundDetectionMode {
        get {
            let rawValue = UserDefaults.standard.string(forKey: soundDetectionModeKey) ?? Constants.defaultSoundDetectionMode.rawValue
            return SoundDetectionMode(rawValue: rawValue) ?? Constants.defaultSoundDetectionMode
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: soundDetectionModeKey)
        }
    }

    static var noiseLoudnessFactorLimit: Int {
        get {
            if UserDefaults.standard.object(forKey: noiseLevelKey) == nil {
                return Constants.loudnessFactorLimit
            } else {
                return UserDefaults.standard.integer(forKey: noiseLevelKey)
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: noiseLevelKey)
        }
    }
}
