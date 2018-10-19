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
    weak var babyService: BabyServiceProtocol?

    init(mediaPlayer: MediaPlayerProtocol, babyService: BabyServiceProtocol) {
        self.mediaPlayer = mediaPlayer
        self.babyService = babyService
        mediaPlayer.startupConfiguration()
    }

    deinit {
        mediaPlayer.stopVideo()
    }

    // MARK: - Coordinator callback
    var didSelectShowBabies: (() -> Void)?
    var didSelectCancel: (() -> Void)?

    // MARK: - Internal functions
    func selectCancel() {
        didSelectCancel?()
    }

    func play() {
        mediaPlayer.playVideo()
    }

    func selectShowBabies() {
        didSelectShowBabies?()
    }
}
