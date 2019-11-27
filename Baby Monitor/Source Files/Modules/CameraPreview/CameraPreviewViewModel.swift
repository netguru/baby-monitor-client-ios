//
//  CameraPreviewViewModel.swift
//  Baby Monitor
//

import RxSwift

final class CameraPreviewViewModel {
    
    let bag = DisposeBag()
    lazy var baby: Observable<Baby> = babyModelController.babyUpdateObservable
    private(set) var streamResettedPublisher = PublishSubject<Void>()
    private(set) var cancelTap: Observable<Void>?
    private(set) var settingsTap: Observable<Void>?
    
    var shouldPlayPreview = false
    var remoteStream: Observable<MediaStream?> {
        return webSocketWebRtcService.get().mediaStream
    }
    lazy var state: Observable<WebRtcClientManagerState> = webSocketWebRtcService.get().state
    
    private let babyModelController: BabyModelControllerProtocol
    private unowned var webSocketWebRtcService: ClearableLazyItem<WebSocketWebRtcServiceProtocol>
    private let connectionChecker: ConnectionChecker
    private let socketCommunicationManager: SocketCommunicationManager
    
    init(webSocketWebRtcService: ClearableLazyItem<WebSocketWebRtcServiceProtocol>,
         babyModelController: BabyModelControllerProtocol,
         connectionChecker: ConnectionChecker,
         socketCommunicationManager: SocketCommunicationManager) {
        self.webSocketWebRtcService = webSocketWebRtcService
        self.babyModelController = babyModelController
        self.connectionChecker = connectionChecker
        self.socketCommunicationManager = socketCommunicationManager
        rxSetup()
    }
    
    // MARK: - Internal functions
    func attachInput(cancelTap: Observable<Void>, settingsTap: Observable<Void>) {
        self.cancelTap = cancelTap
        self.settingsTap = settingsTap
    }
    
    func play() {
        webSocketWebRtcService.get().start()
    }
    
    func stop() {
        webSocketWebRtcService.get().closeWebRtcConnection()
    }
    
    // MARK: - Private functions
    private func rxSetup() {
        connectionChecker.connectionStatus
            .skip(1)
            .filter { $0 == .connected }
            .filter { [weak self] _ in self?.shouldPlayPreview == true }
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
        socketCommunicationManager.communicationResetObservable
            .throttle(1.0, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.play()
                self?.streamResettedPublisher.onNext(())
            })
            .disposed(by: bag)
    }
}
