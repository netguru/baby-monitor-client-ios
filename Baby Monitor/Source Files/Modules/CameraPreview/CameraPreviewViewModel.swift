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
    
    var isThisViewAlreadyShown = false
    var remoteStream: Observable<MediaStream?> {
        return webSocketWebRtcService.mediaStream
    }
    
    private let babyModelController: BabyModelControllerProtocol
    private let webSocketWebRtcService: WebSocketWebRtcServiceProtocol
    private let connectionChecker: ConnectionChecker

    init(webSocketWebRtcService: WebSocketWebRtcServiceProtocol, babyModelController: BabyModelControllerProtocol, connectionChecker: ConnectionChecker) {
        self.webSocketWebRtcService = webSocketWebRtcService
        self.babyModelController = babyModelController
        self.connectionChecker = connectionChecker
        rxSetup()
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
    
    // MARK: - Private functions
    private func rxSetup() {
        connectionChecker.connectionStatus
            .skip(1)
            .filter { $0 == .connected }
            .filter { [weak self] _ in self?.isThisViewAlreadyShown == true }
            .subscribe(onNext: { [weak self] _ in
                self?.play()
            })
            .disposed(by: bag)
        connectionChecker.connectionStatus
            .filter { $0 == .disconnected }
            .subscribe(onNext: { [weak self] _ in
                self?.stop()
            })
            .disposed(by: bag)
    }
}
