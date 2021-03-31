//
//  URLMediaPlayer.swift
//  Baby Monitor
//

import AVKit

protocol URLMediaPlayer {
    func play()
    func pause()
}

extension AVPlayer: URLMediaPlayer {}
