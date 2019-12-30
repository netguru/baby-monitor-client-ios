//
//  DashboardViewModel.swift
//  Baby Monitor
//

import Foundation
import RxCocoa
import RxSwift
import AVFoundation

final class DashboardViewModel {
    
    private let babyModelController: BabyModelControllerProtocol
    private(set) var bag = DisposeBag()
    
    // MARK: - Coordinator callback
    private(set) var liveCameraPreview: Observable<Void>?
    private(set) var activityLogTap: Observable<Void>?
    private(set) var settingsTap: Observable<Void>?
    private var shouldPushNotificationsKeyBeSent = true
    
    private let dismissImagePickerSubject = PublishRelay<Void>()
    private let microphonePermissionProvider: MicrophonePermissionProviderProtocol
    unowned private var webSocketEventMessageService: WebSocketEventMessageServiceProtocol
    unowned private var socketCommunicationManager: SocketCommunicationManager
    
    lazy var baby: Observable<Baby> = babyModelController.babyUpdateObservable
    var connectionStateObservable: Observable<WebSocketConnectionStatus> {
        socketCommunicationManager.connectionStatusObservable
    }
    
    // MARK: - Private properties
    private let networkDiscoveryConnectionStateProvider: ConnectionChecker
    
    init(
        networkDiscoveryConnectionStateProvider: ConnectionChecker,
        socketCommunicationManager: SocketCommunicationManager,
        babyModelController: BabyModelControllerProtocol,
        webSocketEventMessageService: WebSocketEventMessageServiceProtocol,
        microphonePermissionProvider: MicrophonePermissionProviderProtocol
    ) {
        self.networkDiscoveryConnectionStateProvider = networkDiscoveryConnectionStateProvider
        self.babyModelController = babyModelController
        self.webSocketEventMessageService = webSocketEventMessageService
        self.microphonePermissionProvider = microphonePermissionProvider
        self.socketCommunicationManager = socketCommunicationManager
        
        setup()
        rxSetup()
    }
    
    deinit {
        networkDiscoveryConnectionStateProvider.stop()
    }
    
    func attachInput(liveCameraTap: Observable<Void>, activityLogTap: Observable<Void>, settingsTap: Observable<Void>) {
        liveCameraPreview = liveCameraTap
            .flatMapLatest { [unowned self] _ in
            self.microphonePermissionProvider.getMicrophonePermission()
        }
        self.activityLogTap = activityLogTap
        self.settingsTap = settingsTap
    }
    
    /// Sets a new photo for the current baby.
    ///
    /// - Parameter photo: A new photo for baby.
    func updatePhoto(_ photo: UIImage) {
        babyModelController.updatePhoto(photo)
    }
    
    private func setup() {
        networkDiscoveryConnectionStateProvider.start()
        webSocketEventMessageService.start()
    }
    
    private func rxSetup() {
        networkDiscoveryConnectionStateProvider.connectionStatus
            .subscribe(onNext: { [weak self] status in
                self?.sendPushNotificationIfNeeded(connectionStatus: status)
            })
            .disposed(by: bag)
    }
    
    private func sendPushNotificationIfNeeded(connectionStatus: ConnectionStatus) {
        guard shouldPushNotificationsKeyBeSent && connectionStatus == .connected else { return }
        
        let firebaseTokenMessage = EventMessage.initWithPushNotificationsKey(key: UserDefaults.selfPushNotificationsToken)
        self.webSocketEventMessageService.sendMessage(firebaseTokenMessage.toStringMessage())
        self.shouldPushNotificationsKeyBeSent = false
    }
}
