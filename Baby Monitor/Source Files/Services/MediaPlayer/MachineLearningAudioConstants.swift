//
//  MachineLearningAudioConstants.swift
//  Baby Monitor

import AVFoundation

/// Constants that are set as machine learning requirement for audio send to the model.
enum MachineLearningAudioConstants {

    /// A sample rate that audio needs to have.
    static let sampleRate = 44100.0

    /// A number of channels that audio needs to have.
    static let channels: UInt32 = 1

    /// An audio format.
    static let audioFormat: AVAudioCommonFormat = .pcmFormatFloat32

    /// A buffer size.
    static let bufferSize: UInt32 = 264600

    /// Specifies whether audio should be interleaved.
    static let isInterleaved = false

    /// An NSNumber integer that indicates the bit depth for a linear PCM audio format—one of 8, 16, 24, or 32.
    static let bitDepthKey = 32

    /// A Boolean value that indicates whether the audio format is floating point (true) or fixed point (false).
    static let isFloat = true
}
