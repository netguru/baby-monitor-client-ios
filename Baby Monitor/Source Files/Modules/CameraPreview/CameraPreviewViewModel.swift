//
//  CameraPreviewViewModel.swift
//  Baby Monitor
//

import RxSwift

final class CameraPreviewViewModel {

    private let babyRepo: BabiesRepositoryProtocol
    lazy var baby: Observable<Baby> = babyRepo.babyUpdateObservable
    private let webSocketWebRtcService: WebSocketWebRtcServiceProtocol
    var remoteStream: Observable<MediaStream?> {
        return webSocketWebRtcService.mediaStream
    }

    init(webSocketWebRtcService: WebSocketWebRtcServiceProtocol, babyRepo: BabiesRepositoryProtocol) {
        self.webSocketWebRtcService = webSocketWebRtcService
        self.babyRepo = babyRepo
    }
    
    // MARK: - Coordinator callback
    var didSelectShowBabies: (() -> Void)?
    var didSelectCancel: (() -> Void)?
    
    // MARK: - Internal functions
    func selectCancel() {
        didSelectCancel?()
    }

    func play() {
        webSocketWebRtcService.start()
    }

    func selectShowBabies() {
        didSelectShowBabies?()
    }
}
