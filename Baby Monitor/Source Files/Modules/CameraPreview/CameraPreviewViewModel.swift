//
//  CameraPreviewViewModel.swift
//  Baby Monitor
//

import RxSwift

final class CameraPreviewViewModel {

    let bag = DisposeBag()
    lazy var baby: Observable<Baby> = babyModelController.babyUpdateObservable
    private(set) var cancelTap: Observable<Void>?
    private(set) var settingsTap: Observable<Void>?
    var remoteStream: Observable<MediaStream?> {
        return webSocketWebRtcService.mediaStream
    }
    lazy var state: Observable<WebRtcClientManagerState> = webSocketWebRtcService.state
    
    private let babyModelController: BabyModelControllerProtocol
    private let webSocketWebRtcService: WebSocketWebRtcServiceProtocol

    init(webSocketWebRtcService: WebSocketWebRtcServiceProtocol, babyModelController: BabyModelControllerProtocol) {
        self.webSocketWebRtcService = webSocketWebRtcService
        self.babyModelController = babyModelController
    }
    
    // MARK: - Internal functions
    func attachInput(cancelTap: Observable<Void>, settingsTap: Observable<Void>) {
        self.cancelTap = cancelTap
        self.settingsTap = settingsTap
    }

    func play() {
        webSocketWebRtcService.start()
    }

    func stop() {
        webSocketWebRtcService.close()
    }
    
}
