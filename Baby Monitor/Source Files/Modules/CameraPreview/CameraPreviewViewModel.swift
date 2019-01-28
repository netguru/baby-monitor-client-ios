//
//  CameraPreviewViewModel.swift
//  Baby Monitor
//

import RxSwift

final class CameraPreviewViewModel {

    private let babyModelController: BabyModelControllerProtocol
    lazy var baby: Observable<Baby> = babyModelController.babyUpdateObservable
    private let webSocketWebRtcService: WebSocketWebRtcServiceProtocol
    var remoteStream: Observable<MediaStream?> {
        return webSocketWebRtcService.mediaStream
    }

    init(webSocketWebRtcService: WebSocketWebRtcServiceProtocol, babyModelController: BabyModelControllerProtocol) {
        self.webSocketWebRtcService = webSocketWebRtcService
        self.babyModelController = babyModelController
    }
    
    // MARK: - Coordinator callback
    var didSelectCancel: (() -> Void)?
    
    // MARK: - Internal functions
    func selectCancel() {
        didSelectCancel?()
    }

    func play() {
        webSocketWebRtcService.start()
    }
}
