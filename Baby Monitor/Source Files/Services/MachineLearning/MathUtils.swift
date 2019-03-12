//
//  MathUtils.swift
//  Baby Monitor
//

import Foundation

enum MathUtils {
    enum MathUtilsError: Error {
        case parameterError(String)
    }

    static var nextPowerOfTwo: (Int) -> Int = {(value: Int) -> Int in
        return Int(pow(2, ceil(log2(Double(value)))))
    }
    
    static var freqToMel: (Double) -> Double = {(freq: Double) -> Double in
        return 1127.0 * log(1.0 + (freq / 700.0))
    }
}
