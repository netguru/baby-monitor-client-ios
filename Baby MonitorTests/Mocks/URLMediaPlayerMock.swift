//
//  URLMediaPlayerMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

class URLMediaPlayerMock: URLMediaPlayer {
    
    private(set) var isPlaying: Bool = false
    
    func play() {
        isPlaying = true
    }
    
    func pause() {
        isPlaying = false
    }
}
