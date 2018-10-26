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
    private let babyRepo: BabiesRepositoryProtocol

    init(mediaPlayer: MediaPlayerProtocol, babyRepo: BabiesRepositoryProtocol) {
        self.mediaPlayer = mediaPlayer
        self.babyRepo = babyRepo
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
        guard let baby = babyRepo.fetchAllBabies().first else { return }
        didLoadBabies?(baby)
    }
    
    /// Sets observer to react to changes in the baby.
    ///
    /// - Parameter observer: An object conformed to BabyRepoObserver protocol.
    func addObserver(_ observer: BabyRepoObserver) {
        babyRepo.addObserver(observer)
    }
    
    /// Removes observer to react to changes in the baby.
    ///
    /// - Parameter observer: An object conformed to BabyRepoObserver protocol.
    func removeObserver(_ observer: BabyRepoObserver) {
        babyRepo.removeObserver(observer)
    }
}
