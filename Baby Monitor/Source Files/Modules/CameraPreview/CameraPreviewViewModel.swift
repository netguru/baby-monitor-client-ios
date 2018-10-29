//
//  CameraPreviewViewModel.swift
//  Baby Monitor
//

import RxSwift

final class CameraPreviewViewModel {

    private let mediaPlayer: MediaPlayerProtocol

    weak var videoDataSource: MediaPlayerDataSource? {
        didSet {
            mediaPlayer.dataSource = videoDataSource
        }
    }
    private let babyRepo: BabiesRepositoryProtocol
    lazy var baby: Observable<Baby> = babyRepo.babyUpdateObservable

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
