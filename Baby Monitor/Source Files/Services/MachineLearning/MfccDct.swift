//
//  MfccDct.swift
//  audio_ops
//
//  Created by Timo Rohner on 17/02/2019.
//  Copyright © 2019 Timo Rohner. All rights reserved.
//

import Foundation

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
