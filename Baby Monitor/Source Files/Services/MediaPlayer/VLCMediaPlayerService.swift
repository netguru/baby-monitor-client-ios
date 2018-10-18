//
//  VLCMediaPlayerService.swift
//  Baby Monitor
//

import Foundation

final class VLCMediaPlayerService: MediaPlayerProtocol {
    
    private let mediaPlayer = VLCMediaPlayer()
    // For now we type URL manually, ticket: https://netguru.atlassian.net/browse/BM-75
    private let media = VLCMedia(url: URL(string: "rtsp://10.10.200.206:5006")!)
    
    weak var dataSource: MediaPlayerDataSource? {
        didSet {
            mediaPlayer.drawable = dataSource?.videoView
        }
    }
    
    init() {
        mediaPlayer.media = media
    }
    
    func play() {
        mediaPlayer.play()
    }
    
    func pause() {
        mediaPlayer.pause()
    }
}
