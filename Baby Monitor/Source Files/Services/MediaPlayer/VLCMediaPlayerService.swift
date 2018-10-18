//
//  VLCMediaPlayerService.swift
//  Baby Monitor
//

import Foundation

final class VLCMediaPlayerService: MediaPlayerProtocol {
    
    private let mediaPlayer = VLCMediaPlayer()
    private let netServiceClient: NetServiceClientProtocol
    
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
    
    init(netServiceClient: NetServiceClientProtocol) {
        self.netServiceClient = netServiceClient
    }
    
    func startupConfiguration() {
        netServiceClient.findService()
        netServiceClient.didFindServiceWith = { [weak self] ip, port in
            guard let self = self,
                let urlPath = URL(string: "rtsp://\(ip):\(port)") else {
                    return
            }
            self.media = VLCMedia(url: urlPath)
            self.mediaPlayer.media = self.media
            self.mediaPlayer.play()
        }
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
