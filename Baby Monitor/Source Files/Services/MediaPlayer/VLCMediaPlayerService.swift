//
//  VLCMediaPlayerService.swift
//  Baby Monitor
//

import Foundation

final class VLCMediaPlayerService: MediaPlayerProtocol {
    
    private let mediaPlayer = VLCMediaPlayer()
    private let netServiceClient: NetServiceClientProtocol
    private let rtspConfiguration: RTSPConfiguration
    
    private var media: VLCMedia?
    
    weak var dataSource: MediaPlayerDataSource? {
        didSet {
            mediaPlayer.drawable = dataSource?.videoView
            if let media = media {
                mediaPlayer.media = media
                mediaPlayer.play()
            }
        }
    }
    
    init(netServiceClient: NetServiceClientProtocol, rtspConfiguration: RTSPConfiguration) {
        self.netServiceClient = netServiceClient
        self.rtspConfiguration = rtspConfiguration
    }
    
    func startupConfiguration() {
        guard let url = rtspConfiguration.url else {
            return
        }
        self.media = VLCMedia(url: url)
        self.mediaPlayer.media = self.media
        self.mediaPlayer.play()
    }
    
    func playVideo() {
        mediaPlayer.play()
    }
    
    func pauseVideo() {
        mediaPlayer.pause()
    }
    
    func stopVideo() {
        mediaPlayer.stop()
    }
}
