//
//  CameraPreviewViewModel.swift
//  Baby Monitor
//

import RxSwift

final class CameraPreviewViewModel {

    private let babyRepo: BabiesRepositoryProtocol
    lazy var baby: Observable<Baby> = babyRepo.babyUpdateObservable
    private let webSocketsService: WebSocketsServiceProtocol
    var remoteStream: Observable<RTCMediaStream?> {
        return webSocketsService.mediaStream
    }

    init(webSocketsService: WebSocketsServiceProtocol, babyRepo: BabiesRepositoryProtocol) {
        self.webSocketsService = webSocketsService
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
        webSocketsService.play()
    }

    func selectShowBabies() {
        didSelectShowBabies?()
    }
}
