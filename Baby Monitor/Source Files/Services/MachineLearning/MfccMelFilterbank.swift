//
//  MfccMelFilterbank.swift
//  audio_ops
//
//  Created by Timo Rohner on 17/02/2019.
//  Copyright © 2019 Timo Rohner. All rights reserved.
//

import Foundation
import Accelerate

/**
 This class provides computation functionality to calculate the Mel filterbank associated with a spectrogram generated from a linear raw pcm audio signal and it mirrors the corresponding tensorflow kernel, whose implementation can be found here: https://github.com/tensorflow/tensorflow/blob/master/tensorflow/core/kernels/mfcc_mel_filterbank.h
 */
class MfccMelFilterbank {
    
    enum MfccMelFilterbankError: Error {
        case parameterError(String)
    }
    
    var initialized: Bool = false
    var numChannels: Int
    var sampleRate: Double
    var inputLength: Int
    var centerFrequencies: [Double]?
    var bandMapper: [Int]?
    var weights: [Double]?
    var startIndex: Int
    var endIndex: Int
    var workData: [Float]?

    init() {
        numChannels = 0
        sampleRate = 0.0
        inputLength = 0
        startIndex = 0
        endIndex = 0
    }
    
    /**
     Initializes needed variables to execute the filterbank computation.
     - Parameter inputLength: Spectrogram input length
     - Parameter inputSampleRate: Sample rate of the audio signal from which the Spectrogram was calculated
     - Parameter outputChannelCount: How many channels we would like to generate
     - Parameter lowerFrequencyLimit: lower frequency limit of our filterbank
     - Parameter upperFrequencyLimit: upper frequency limit of our filterbank
     */
    func initialize(inputLength: Int, inputSampleRate: Double, outputChannelCount: Int, lowerFrequencyLimit: Double, upperFrequencyLimit: Double) throws {
        self.inputLength = inputLength
        self.sampleRate = inputSampleRate
        self.numChannels = outputChannelCount
        
        let melLow = MfccMelFilterbank.freqToMel(freq: lowerFrequencyLimit)
        let melHi = MfccMelFilterbank.freqToMel(freq: upperFrequencyLimit)
        let melSpan = melHi - melLow
        let melSpacing = melSpan / Double(numChannels + 1)
        
        centerFrequencies = [Double](repeating: 0.0, count: numChannels + 1)
        
        for i in 0...numChannels {
            centerFrequencies![i] = melLow + (melSpacing * Double(i + 1))
        }

        let hzPerSbin = 0.5 * sampleRate / Double(inputLength - 1)
        startIndex = Int(1.5 + (lowerFrequencyLimit / hzPerSbin))
        endIndex = Int(upperFrequencyLimit / hzPerSbin)
        
        bandMapper = [Int](repeating: 0, count: self.inputLength)
        
        var channel = 0
        
        // Initialize freq to band mapping index matrix
        for i in 0..<self.inputLength {
            let melf = MfccMelFilterbank.freqToMel(freq: Double(i) * hzPerSbin)
            if (i < startIndex) || (i > endIndex) {
                bandMapper![i] = -2
            } else {
                while (centerFrequencies![channel] < melf) && (channel < numChannels) {
                        channel += 1
                }
                bandMapper![i] = channel - 1
            }
        }
        
        // Initialize weight matrix
        weights = [Double](repeating: 0.0, count: self.inputLength)
        for i in 0..<self.inputLength {
            channel = bandMapper![i]
            if (i < startIndex) || (i > endIndex) {
                weights![i] = 0.0
            } else {
                let melFrequencyBin = MfccMelFilterbank.freqToMel(freq: Double(i) * hzPerSbin)
                if channel >= 0 {
                    weights![i] = (centerFrequencies![channel + 1] - melFrequencyBin) / (centerFrequencies![channel + 1] - centerFrequencies![channel])
                } else {
                    weights![i] = (centerFrequencies![0] - melFrequencyBin) / (centerFrequencies![0] - melLow)
                }
            }
        }
        
        // Allocated memory that we will need to evaluate on input data
        workData = [Float](repeating: 0.0, count: endIndex - startIndex + 1)
        initialized = true
    }
    
    /**
     Compute the Filterbank for a given input and write to output
     - Parameter input: Pointer to input
     - Parameter output: Pointer to output. Memory allocation is on the caller of this method
     */
    func compute(input: UnsafeMutablePointer<Float>, output: UnsafeMutablePointer<Float>) {
        for i in startIndex...endIndex {
            let specVal = sqrtf(input.advanced(by: i).pointee)
            let weighted = specVal * Float((weights![i]))
            var channel = bandMapper![i]
            if channel >= 0 {
                output.advanced(by: channel).pointee += weighted
            }
            channel += 1
            
            if channel < numChannels {
                output.advanced(by: channel).pointee += specVal - weighted
            }
        }
    }
    
    /**
     Calculates the Mel value of a given frequency
     - Parameter freq: Frequency for which to calculate the corresponding mel value
     - Returns: Mel value corresponding to the frequency given by parameter freq
     */
    static func freqToMel(freq: Double) -> Double {
        return 1127.0 * log(1.0 + (freq / 700.0))
    }
}
