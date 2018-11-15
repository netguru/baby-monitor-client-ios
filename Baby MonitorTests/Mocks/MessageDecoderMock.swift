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
<<<<<<< HEAD
        return words.contains(message) ? true : nil
=======
        if words.contains(message) { return true }
        return nil
>>>>>>> d2863fb... Replaced RTSP with WebRTC
    }
}
