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
    private let babyService: BabyServiceProtocol

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
    var didLoadBabies: ((_ baby: Baby) -> Void)?

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
    
    func loadBabies() {
        guard let baby = babyService.dataSource.babies.first else { return }
        didLoadBabies?(baby)
    }
    
    /// Sets observer to react to changes in the baby.
    ///
    /// - Parameter controller: A controller conformed to BabyServiceObserver.
    func addObserver(_ observer: BabyServiceObserver) {
        babyService.addObserver(observer)
    }
    
    /// Removes observer to react to changes in the baby.
    ///
    /// - Parameter controller: A controller conformed to BabyServiceObserver.
    func removeObserver(_ observer: BabyServiceObserver) {
        babyService.removeObserver(observer)
    }
}
