//
//  SoundDetectionMode.swift
//  Baby Monitor

/// A sound detection mode that should be used on the baby device.
enum SoundDetectionMode: String, Codable, CaseIterable {
    /// A machine learning cry detection mode.
    case cryRecognition = "MachineLearning"

    /// A detection of the noise with setting a limit on parent device.
    case noiseDetection  = "NoiseDetection"

    /// A localized title for a mode.
    var localizedTitle: String {
        switch self {
        case .cryRecognition:
            return Localizable.Settings.cryDetection
        case .noiseDetection:
            return Localizable.Settings.noiseDetection
        }
    }

    /// An activity event mode which is saved to database.
    var activityEventMode: ActivityLogEvent.Mode {
        switch self {
        case .cryRecognition:
            return .cryingEvent
        case .noiseDetection:
            return .noiseEvent
        }
    }
}
