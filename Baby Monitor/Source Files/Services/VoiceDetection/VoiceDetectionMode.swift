//
//  VoiceDetectionMode.swift
//  Baby Monitor

enum VoiceDetectionMode: String, Codable, CaseIterable {
    case machineLearningCryRecognition = "MachineLearning"
    case noiseDetection  = "NoiseDetection"

    var localizedTitle: String {
        switch self {
        case .machineLearningCryRecognition:
            return Localizable.Settings.cryDetection
        case .noiseDetection:
            return Localizable.Settings.noiseDetection
        }
    }
}
