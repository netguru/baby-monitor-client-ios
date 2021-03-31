//
//  Randomizer.swift
//  Baby Monitor

import Foundation

/// A random generator.
protocol RandomGenerator {

    /// Generating a random 4 number code.
     func generateRandomCode() -> String
}

struct Randomizer: RandomGenerator {

    func generateRandomCode() -> String {
        return String(Int.random(in: 1000...9999))
    }

}
