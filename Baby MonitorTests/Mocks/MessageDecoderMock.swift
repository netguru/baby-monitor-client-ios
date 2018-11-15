//
//  MessageDecoderMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

final class MessageDecoderMock: MessageDecoderProtocol {
    
    typealias T = Bool
    
    private let words: Set<String>
    
    init(words: Set<String>) {
        self.words = words
    }
    
    func decode(message: String) -> Bool? {
        if words.contains(message) { return true }
        return nil
    }
}
