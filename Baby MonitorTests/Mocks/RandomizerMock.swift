//
//  RandomizerMock.swift
//  Baby MonitorTests

@testable import BabyMonitor
import Foundation

class RandomizerMock: RandomGenerator {

    func generateRandomCode() -> Int {
        return 7777
    }
}
