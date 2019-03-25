//
//  MathUtilities.swift
//  Baby Monitor
//

extension UInt {
    var nextPowerOfTwo: UInt { return UInt(pow(2, ceil(log2(Double(self)))))}
}
