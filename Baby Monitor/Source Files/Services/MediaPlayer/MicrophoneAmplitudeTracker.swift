//
//  MicrophoneAmplitudeTracker.swift
//  Baby Monitor

import Foundation
import AudioKit

protocol MicrophoneAmplitudeTracker: Any {
    var amplitude: Double { get }
    var loudnessFactor: Double { get }
    var decibels: Double { get }
}

struct MicrophoneAmplitudeInfo {
    var loudnessFactor: Double
    var decibels: Double
}

extension AKAmplitudeTracker: MicrophoneAmplitudeTracker {

    var loudnessFactor: Double {
        return min(amplitude * 1000, 100)
    }

    var decibels: Double {
        var value = 20.0 * log10(amplitude) + 120
        value = max(0, value)
        return value
    }
}
