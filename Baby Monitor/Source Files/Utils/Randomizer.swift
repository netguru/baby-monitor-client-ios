//
//  Randomizer.swift
//  Baby Monitor

import Foundation

/// A random generator.
protocol RandomGenerator {

    /// Generating a random 4 number code.
     func generateRandomCode() -> Int
}

struct Randomizer: RandomGenerator {

    func generateRandomCode() -> Int {
        return Int.random(in: 1000...9999)
    }
}
