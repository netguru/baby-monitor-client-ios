//
//  MicrophoneAmplitudeTracker.swift
//  Baby Monitor

import Foundation
import AudioKit

/// A tracker that detects amplitude from the microphone.
protocol MicrophoneAmplitudeTracker: Any {

    /// The loudness factor customly counted in order to get percentage from 0 to 100 result.
    /// The amlitude multipled by the special factor.
    var loudnessFactor: Double { get }

    /// A current level of decibels of the sound captured.
    var decibels: Double { get }
}

/// An additional info to the amplitude.
struct MicrophoneAmplitudeInfo {

    /// The loudness factor customly counted in order to get percentage from 0 to 100 result.
    /// The amplitude multiplied by the special factor.
    var loudnessFactor: Double

    /// A current level of decibels of the sound captured.
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
