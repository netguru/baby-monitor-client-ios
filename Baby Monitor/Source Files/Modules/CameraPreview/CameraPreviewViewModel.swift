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
    var connectionStatusObservable: Observable<WebSocketConnectionStatus> {
        webSocketWebRtcService.get().connectionStatusObservable
    }
    
    private let babyModelController: BabyModelControllerProtocol
    private unowned var webSocketWebRtcService: ClearableLazyItem<WebSocketWebRtcServiceProtocol>
    private unowned var socketCommunicationManager: SocketCommunicationManager
    
    init(webSocketWebRtcService: ClearableLazyItem<WebSocketWebRtcServiceProtocol>,
        babyModelController: BabyModelControllerProtocol,
        socketCommunicationManager: SocketCommunicationManager) {
        self.webSocketWebRtcService = webSocketWebRtcService
        self.babyModelController = babyModelController
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
        connectionStatusObservable
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                self?.handleStateChange(state: $0)
            })
            .disposed(by: bag)
        socketCommunicationManager.communicationResetObservable
            .subscribe(onNext: { [weak self] in
                self?.play()
                self?.streamResettedPublisher.onNext(())
            })
            .disposed(by: bag)
    }
    
    private func handleStateChange(state: WebSocketConnectionStatus) {
        switch state {
        case .connected where shouldPlayPreview:
            play()
        case .disconnected:
            stop()
        default:
            print("connection status: connecting")
        }
    }
}
