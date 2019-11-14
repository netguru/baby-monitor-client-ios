//
//  AppDependencies.swift
//  Baby Monitor
//

import Foundation
import RealmSwift
import RxSwift
import PocketSocket
import AudioKit
import FirebaseMessaging
import WebRTC

final class AppDependencies {
    
    private let bag = DisposeBag()
    
    // MARK: - Audio & Crying
    
    /// Service for detecting baby's cry
    private(set) lazy var cryingDetectionService: CryingDetectionServiceProtocol = CryingDetectionService(microphoneCaptureService: audioMicrophoneService)
    
    /// Service that takes care of appropriate controling: crying detection, audio recording and saving these events to realm database
    private(set) lazy var cryingEventService: CryingEventsServiceProtocol = CryingEventService(
        cryingDetectionService: cryingDetectionService,
        microphoneRecordService: audioMicrophoneService,
        activityLogEventsRepository: databaseRepository,
        storageService: storageServerService)
    
    /// Service for capturing/recording microphone audio
    private(set) lazy var audioMicrophoneService: AudioMicrophoneServiceProtocol? = try? AudioMicrophoneService(microphoneFactory: AudioKitMicrophoneFactory.makeMicrophoneFactory)
    
    let microphonePermissionProvider: MicrophonePermissionProviderProtocol = MicrophonePermissionProvider()
    
    // MARK: - Bonjour
    
    private(set) lazy var netServiceClient: NetServiceClientProtocol = NetServiceClient(serverErrorLogger: serverErrorLogger)
    
    private(set) lazy var netServiceServer: NetServiceServerProtocol = NetServiceServer(appStateProvider: NotificationCenter.default, serverErrorLogger: serverErrorLogger)
    
    private(set) lazy var connectionChecker: ConnectionChecker = NetServiceConnectionChecker(netServiceClient: netServiceClient, urlConfiguration: urlConfiguration)
    
    // MARK: - WebRTC
    
    private(set) lazy var webRtcServer: () -> WebRtcServerManagerProtocol = {
        WebRtcServerManager(peerConnectionFactory: self.peerConnectionFactory)
    }
    
    private(set) lazy var webRtcClient: () -> WebRtcClientManagerProtocol = {
        WebRtcClientManager(
            peerConnectionFactory: self.peerConnectionFactory,
            connectionChecker: self.connectionChecker,
            appStateProvider: NotificationCenter.default
        )
    }
    
    private(set) var webRtcMessageDecoders: [AnyMessageDecoder<WebRtcMessage>] = [AnyMessageDecoder<WebRtcMessage>(SdpOfferDecoder()), AnyMessageDecoder<WebRtcMessage>(SdpAnswerDecoder()), AnyMessageDecoder<WebRtcMessage>(IceCandidateDecoder())]
    
    private(set) lazy var peerConnectionFactory: PeerConnectionFactoryProtocol = RTCPeerConnectionFactory()
    
    // MARK: - WebSockets
    
    private lazy var eventMessageConductorFactory: (Observable<String>, AnyObserver<EventMessage>?) -> WebSocketConductor<EventMessage> = { emitter, handler in
        WebSocketConductor(
            webSocket: self.webSocket,
            messageEmitter: emitter,
            messageHandler: handler,
            messageDecoders: [self.babyMonitorEventMessagesDecoder]
        )
    }
    
    lazy var webSocketEventMessageService = ClearableLazyItem<WebSocketEventMessageServiceProtocol> { [unowned self] in
        return WebSocketEventMessageService(
            cryingEventsRepository: self.databaseRepository,
            eventMessageConductorFactory: self.eventMessageConductorFactory)
    }
    
    lazy var webSocketWebRtcService = ClearableLazyItem<WebSocketWebRtcServiceProtocol> { [unowned self] in
        return WebSocketWebRtcService(
            webRtcClientManager: self.webRtcClient(),
            webSocketConductorFactory: self.webSocketConductorFactory)
    }
    
    private(set) lazy var messageServer = MessageServer(server: webSocketServer)
    
    private(set) lazy var webSocketServer: WebSocketServerProtocol = {
        let webSocketServer = PSWebSocketServer(host: nil, port: UInt(Constants.iosWebsocketPort))!
        return PSWebSocketServerWrapper(server: webSocketServer)
    }()
    
    private lazy var webSocket = ClearableLazyItem<WebSocketProtocol?> { [unowned self] in
        guard let url = self.urlConfiguration.url else {
            return nil
        }
        guard let rawSocket = PSWebSocket.clientSocket(with: URLRequest(url: url)) else {
            return nil
        }
        let webSocket = PSWebSocketWrapper(socket: rawSocket)
        webSocket.disconnectionObservable
            .subscribe(onNext: { [weak self] in self?.clearSockets() })
            .disposed(by: self.bag)
        return webSocket
    }
    
    private lazy var webSocketConductorFactory: (Observable<String>, AnyObserver<WebRtcMessage>) -> WebSocketConductor<WebRtcMessage> = { emitter, handler in
        WebSocketConductor(
            webSocket: self.webSocket,
            messageEmitter: emitter,
            messageHandler: handler,
            messageDecoders: self.webRtcMessageDecoders
        )
    }
    
    // MARK: - Notifications
    
    private(set) lazy var localNotificationService: NotificationServiceProtocol = NotificationService(
        networkDispatcher: networkDispatcher,
        serverKeyObtainable: serverKeyObtainable)
    
    private(set) lazy var networkDispatcher: NetworkDispatcherProtocol = NetworkDispatcher(
        urlSession: URLSession(configuration: .default),
        dispatchQueue: DispatchQueue(label: "NetworkDispatcherQueue"))
    
    private let serverKeyObtainable: ServerKeyObtainableProtocol = ServerKeyObtainable()
    
    private(set) var babyMonitorEventMessagesDecoder = AnyMessageDecoder<EventMessage>(EventMessageDecoder())
    
    private(set) lazy var serverService: ServerServiceProtocol = ServerService(
        webRtcServerManager: webRtcServer(),
        messageServer: messageServer,
        netServiceServer: netServiceServer,
        webRtcDecoders: webRtcMessageDecoders,
        cryingService: cryingEventService,
        babyModelController: databaseRepository,
        notificationsService: localNotificationService,
        babyMonitorEventMessagesDecoder: babyMonitorEventMessagesDecoder
    )
    
    private(set) var urlConfiguration: URLConfiguration = UserDefaultsURLConfiguration()
    
    // MARK: - Persistence
    
    /// Baby service for getting and adding babies throughout the app
    private(set) lazy var databaseRepository: BabyModelControllerProtocol & ActivityLogEventsRepositoryProtocol = RealmBabiesRepository(realm: try! Realm())
    
    /// Service for cleaning too many crying events from application's directory
    private(set) lazy var memoryCleaner: MemoryCleanerProtocol = MemoryCleaner()
    
    // Service for uploading crying tracks to Firebase & removing uploaded ones
    private(set) lazy var storageServerService = FirebaseStorageService(memoryCleaner: memoryCleaner)
    
    // MARK: - Errors
    
    /// Service for handling errors and showing error alerts
    private(set) var errorHandler: ErrorHandlerProtocol = ErrorHandler()
    
    /// Service for sending errors to the server.
    private(set) var serverErrorLogger: ServerErrorLogger = CrashlyticsErrorLogger()
    
    // MARK: - Utilities
    
    /// Provides app version and build number
    private(set) var appVersionProvider: AppVersionProvider = DefaultAppVersionProvider()
    
    /// Application reset utility
    private(set) lazy var applicationResetter: ApplicationResetter = {
        [unowned self] in
        let resetter = DefaultApplicationResetter(
            messageServer: messageServer,
            webSocketEventMessageService: webSocketEventMessageService,
            babyModelControllerProtocol: databaseRepository,
            memoryCleaner: memoryCleaner,
            urlConfiguration: urlConfiguration,
            webSocketWebRtcService: webSocketWebRtcService,
            localNotificationService: localNotificationService)
        resetter.localResetCompleted.asObservable()
            .distinctUntilChanged()
            .filter {
                $0 == true
            }.subscribe(onNext: {
                [weak self] resetCompleted in
                self?.clearSockets()
            }).disposed(by: bag)
        return resetter
    }()
}

// MARK: - Resetting app state
extension AppDependencies {
    
    func clearSockets() {
        webSocketWebRtcService.clear()
        webSocketEventMessageService.clear()
        webSocket.clear()
    }
}
