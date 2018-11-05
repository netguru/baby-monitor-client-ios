//
//  LullabyPlayer.swift
//  Baby Monitor
//

import AVKit

private extension Lullaby {
    
    func playerItem(for bundle: Bundle) -> AVPlayerItem? {
        guard let url = type.url(identifier: identifier, for: bundle) else {
            return nil
        }
        return AVPlayerItem(url: url)
    }
}

private extension LullabyType {
    
    func url(identifier: String, for bundle: Bundle) -> URL? {
        switch self {
        case .bmLibrary:
            return bundle.url(forResource: identifier, withExtension: ".mp3")
        case .yourLullabies:
            return URL(string: identifier)
        }
    }
}

final class LullabyPlayer: LullabyPlayerProtocol {
    
    private var player: URLMediaPlayer?
    private let playerFactory: (AVPlayerItem) -> URLMediaPlayer
    private let bundle: Bundle
    private var currentLullaby: Lullaby?
    
    init(bundle: Bundle = Bundle.main, playerFactory: @escaping (AVPlayerItem) -> URLMediaPlayer = { item in return AVPlayer(playerItem: item) }) {
        self.playerFactory = playerFactory
        self.bundle = bundle
    }
    
    func play(lullaby: Lullaby) {
        guard lullaby != currentLullaby else {
            player?.play()
            return
        }
        guard let playerItem = lullaby.playerItem(for: bundle) else {
            return
        }
        currentLullaby = lullaby
        player?.pause()
        player = playerFactory(playerItem)
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
}
