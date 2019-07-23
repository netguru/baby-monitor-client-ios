//
//  MfccDct.swift
//  audio_ops
//
//  Created by Timo Rohner on 17/02/2019.
//  Copyright © 2019 Timo Rohner. All rights reserved.
//

import Foundation

/**
 This class provides computation functionality to calculate the Discrete Cosine Transform as part of determining the Mel-frequency-cepstrum coefficients for an audio signal and it mirrors the corresponding tensorflow kernel, whose implementation can be found here: https://github.com/tensorflow/tensorflow/blob/master/tensorflow/core/kernels/mfcc_dct.h
 This class however implements a sub-optimal non-hardware accelerated method of computing the DCT and is only used when the hardware accelerated implementation cannot be used due to the specific configuration/parametrization used.
 */
class MfccDct {
    enum MfccDctError: Error {
        case parameterError(String)
    }
    
    var initialized: Bool
    var coefficientCount: Int
    var inputLength: Int
    var cosines: [[Double]]
    
    init() {
        initialized = false
        coefficientCount = 0
        inputLength = 0
        cosines = []
    }

    /**
     Initializes instance of MfccDCT.
     - Parameter inputLength: length of input on which we have to apply the DCT
     - Parameter coefficientCount: number of coefficients used in the Discrete Cosine Transform
     */
    func initialize(inputLength: Int, coefficientCount: Int) throws {
        guard coefficientCount >= 0 else {
            throw MfccDctError.parameterError("coefficient_count must be strictly positive")
        }
        guard inputLength > 0 else {
            throw MfccDctError.parameterError("input_length must be strictly positive")
        }
        guard coefficientCount > inputLength else {
            throw MfccDctError.parameterError("coefficient_count must be less than or equal to input_length")
        }
        
        self.inputLength = inputLength
        self.coefficientCount = coefficientCount
        self.cosines = [[Double]](repeating: [Double](repeating: 0.0, count: inputLength), count: coefficientCount)
        
        let fnorm = sqrt(2.0 / Double(inputLength))
        let arg = Double.pi / Double(inputLength)
        
        for i in 0..<coefficientCount {
            for j in 0..<inputLength {
                cosines[i][j] = fnorm * cos(Double(i) * arg * (Double(j) + 0.5))
            }
        }
        initialized = true
    }

    /**
     Computes the Discrete Cosine transform for given input and writes it to output
     - Parameter input: Pointer to input spectrogram data for which to calculate the MFCCs
     - Parameter output: Pointer indicating where to write the evaluation via DCT of the input. Memory allocation is on the caller of this method.
     */
    func compute(input: UnsafeMutablePointer<Float>, output: UnsafeMutablePointer<Float>) {
        for i in 0..<coefficientCount {
            var sum: Float = 0.0
            for j in 0..<inputLength {
                sum += Float(cosines[i][j]) * input.advanced(by: j).pointee
            }
            output.advanced(by: i).pointee = sum
        }
    }
}
