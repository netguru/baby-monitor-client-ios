//
//  MathUtilities.swift
//  Baby Monitor
//

extension UInt {
    /**
     Calculates the smallest number that is greater than the given UInt and a power of two
     */
    var nextPowerOfTwo: UInt { return UInt(pow(2, ceil(log2(Double(self)))))}
}
