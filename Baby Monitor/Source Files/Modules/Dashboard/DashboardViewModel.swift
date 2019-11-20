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
    private let webSocketEventMessageService: WebSocketEventMessageServiceProtocol
    private let microphonePermissionProvider: MicrophonePermissionProviderProtocol
    
    lazy var baby: Observable<Baby> = babyModelController.babyUpdateObservable
    lazy var connectionStatus: Observable<ConnectionStatus> = connectionChecker.connectionStatus
    
    // MARK: - Private properties
    private let connectionChecker: ConnectionChecker
    
    init(connectionChecker: ConnectionChecker, babyModelController: BabyModelControllerProtocol, webSocketEventMessageService: WebSocketEventMessageServiceProtocol, microphonePermissionProvider: MicrophonePermissionProviderProtocol) {
        self.connectionChecker = connectionChecker
        self.babyModelController = babyModelController
        self.webSocketEventMessageService = webSocketEventMessageService
        self.microphonePermissionProvider = microphonePermissionProvider
        setup()
        rxSetup()
    }
    
    deinit {
        connectionChecker.stop()
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
    
    // MARK: - Private functions
    private func setup() {
        connectionChecker.start()
    }
    
    private func rxSetup() {
        connectionChecker.connectionStatus.subscribe(onNext: { [weak self] status in
            guard let self = self, self.shouldPushNotificationsKeyBeSent, status == .connected else {
                return
            }
            let firebaseTokenMessage = EventMessage.initWithPushNotificationsKey(key: UserDefaults.selfPushNotificationsToken)
            self.webSocketEventMessageService.sendMessage(firebaseTokenMessage.toStringMessage())
            self.shouldPushNotificationsKeyBeSent = false
        })
            .disposed(by: bag)
    }
}
