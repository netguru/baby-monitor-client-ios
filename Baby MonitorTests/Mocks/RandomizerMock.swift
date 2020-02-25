//
//  RandomizerMock.swift
//  Baby MonitorTests

@testable import BabyMonitor
import Foundation

class RandomizerMock: RandomGenerator {

    func generateRandomCode() -> String {
        return "7777"
    }
}
