//
//  CameraPreviewViewModel.swift
//  Baby Monitor
//

import RxSwift

final class CameraPreviewViewModel: BaseViewModel {
    
    let bag = DisposeBag()
    lazy var baby: Observable<Baby> = babyModelController.babyUpdateObservable
    var remoteStreamErrorMessageObservable: Observable<String> {
        return self.webSocketEventMessageService.remoteStreamConnectingErrorObservable
    }
    private(set) var noMicrophoneAccessPublisher = PublishSubject<Void>()
    private(set) var streamResettedPublisher = PublishSubject<Void>()
    private(set) var cancelTap: Observable<Void>?
    private(set) var settingsTap: Observable<Void>?
    private(set) var microphoneHoldEvent: Observable<Void>?
    private(set) var microphoneReleaseEvent: Observable<Void>?
    
    var shouldPlayPreview = false
    var remoteStream: Observable<MediaStream?> {
        return webSocketWebRtcService.get().mediaStream
    }
    var connectionStatusObservable: Observable<WebSocketConnectionStatus> {
        webSocketWebRtcService.get().connectionStatusObservable
    }
    var isMicrophoneAccessGranted: Bool {
        return permissionsService.isMicrophoneAccessGranted
    }
    private let babyModelController: BabyModelControllerProtocol
    private unowned var webSocketWebRtcService: ClearableLazyItem<WebSocketWebRtcServiceProtocol>
    private unowned var socketCommunicationManager: SocketCommunicationManager
    private let webSocketEventMessageService: WebSocketEventMessageServiceProtocol
    private let permissionsService: PermissionsProvider

    init(webSocketWebRtcService: ClearableLazyItem<WebSocketWebRtcServiceProtocol>,
         babyModelController: BabyModelControllerProtocol,
         socketCommunicationManager: SocketCommunicationManager,
         webSocketEventMessageService: WebSocketEventMessageServiceProtocol,
         permissionsService: PermissionsProvider,
         analytics: AnalyticsManager) {
        self.webSocketWebRtcService = webSocketWebRtcService
        self.babyModelController = babyModelController
        self.socketCommunicationManager = socketCommunicationManager
        self.webSocketEventMessageService = webSocketEventMessageService
        self.permissionsService = permissionsService
        super.init(analytics: analytics)
        rxSetup()
    }
    
    // MARK: - Internal functions
    func attachInput(cancelTap: Observable<Void>,
                     settingsTap: Observable<Void>,
                     microphoneHoldEvent: Observable<Void>,
                     microphoneReleaseEvent: Observable<Void>) {
        self.cancelTap = cancelTap
        self.settingsTap = settingsTap
        self.microphoneHoldEvent = microphoneHoldEvent
        self.microphoneReleaseEvent = microphoneReleaseEvent
        rxSetupMicrophoneEvents()
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

    private func rxSetupMicrophoneEvents() {
        microphoneHoldEvent?
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.isMicrophoneAccessGranted {
                    self.webSocketWebRtcService.get().startAudioTransmitting()
                } else {
                    self.noMicrophoneAccessPublisher.onNext(())
                }
            }).disposed(by: bag)
        microphoneReleaseEvent?
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                    self.isMicrophoneAccessGranted else { return }
                self.webSocketWebRtcService.get().stopAudioTransmitting()
            }).disposed(by: bag)
    }
}
