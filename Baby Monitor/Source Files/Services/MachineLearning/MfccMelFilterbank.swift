//
//  MfccMelFilterbank.swift
//  audio_ops
//
//  Created by Timo Rohner on 17/02/2019.
//  Copyright © 2019 Timo Rohner. All rights reserved.
//

import Foundation
import Accelerate

class MfccMelFilterbank {
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
    
    func initialize(inputLength: Int, inputSampleRate: Double, outputChannelCount: Int, lowerFrequencyLimit: Double, upperFrequencyLimit: Double) -> Bool {
        self.inputLength = inputLength
        self.sampleRate = inputSampleRate
        self.numChannels = outputChannelCount
        
        let melLow = freqToMel(freq: lowerFrequencyLimit)
        let melHi = freqToMel(freq: upperFrequencyLimit)
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
        
        for i in 0..<self.inputLength {
            let melf = freqToMel(freq: Double(i) * hzPerSbin)
            if (i < startIndex) || (i > endIndex) {
                bandMapper![i] = -2
            } else {
                while (centerFrequencies![channel] < melf) && (channel < numChannels) {
                        channel += 1
                }
                bandMapper![i] = channel - 1
            }
        }
        
        weights = [Double](repeating: 0.0, count: self.inputLength)
        for i in 0..<self.inputLength {
            channel = bandMapper![i]
            if (i < startIndex) || (i > endIndex) {
                weights![i] = 0.0
            } else {
                if channel >= 0 {
                    weights![i] = (centerFrequencies![channel + 1] - freqToMel(freq: Double(i) * hzPerSbin)) / (centerFrequencies![channel + 1] - centerFrequencies![channel])
                } else {
                    weights![i] = (centerFrequencies![0] - freqToMel(freq: Double(i) * hzPerSbin)) / (centerFrequencies![0] - melLow)
                }
            }
        }
        
        workData = [Float](repeating: 0.0, count: endIndex - startIndex + 1)
        
        initialized = true
        return true
    }
    
    func compute(input: UnsafeMutablePointer<Float>, output: UnsafeMutablePointer<Float>) {
        for i in startIndex...endIndex {
            //let spec_val = sqrtf(input.advanced(by: i).pointee)
            let specVal = input.advanced(by: i).pointee
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
    
    private func freqToMel(freq: Double) -> Double {
        return 1127.0 * log(1.0 + (freq / 700.0))
    }
}
