//
//  CameraPreviewViewModel.swift
//  Baby Monitor
//

import RxSwift
import WebRTC

final class CameraPreviewViewModel {

    private let babyRepo: BabiesRepositoryProtocol
    lazy var baby: Observable<Baby> = babyRepo.babyUpdateObservable
    private let webRtcClientManager: WebRtcClientManagerProtocol
    var remoteStream: Observable<MediaStreamProtocol> {
        return webRtcClientManager.mediaStream
    }

    init(webRtcClientManager: WebRtcClientManagerProtocol, babyRepo: BabiesRepositoryProtocol) {
        self.webRtcClientManager = webRtcClientManager
        self.babyRepo = babyRepo
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
