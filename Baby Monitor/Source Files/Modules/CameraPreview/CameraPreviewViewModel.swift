//
//  CameraPreviewViewModel.swift
//  Baby Monitor
//

import Foundation

final class CameraPreviewViewModel {
    
    private let mediaPlayer: MediaPlayerProtocol
    
    weak var videoDataSource: MediaPlayerDataSource? {
        didSet {
            mediaPlayer.dataSource = videoDataSource
        }
    }
    weak var babyService: BabyService?
    
    init(mediaPlayer: MediaPlayerProtocol, babyService: BabyService) {
        self.mediaPlayer = mediaPlayer
        self.babyService = babyService
    }
    
    // MARK: - Coordinator callback
    var didSelectShowBabies: (() -> Void)?
    var didSelectCancel: (() -> Void)?
    
    // MARK: - Internal functions
    func selectCancel() {
        didSelectCancel?()
    }
    
    func selectShowBabies() {
        didSelectShowBabies?()
    }
}
