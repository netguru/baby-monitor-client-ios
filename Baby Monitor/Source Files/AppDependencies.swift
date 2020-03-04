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

    /// Service which is controlling a sound detection in the app.
    private(set) lazy var soundDetectionService: SoundDetectionServiceProtocol = SoundDetectionService(
        microphoneService: audioMicrophoneService,
        noiseDetectionService: noiseDetectionService,
        cryingDetectionService: cryingDetectionService,
        cryingEventService: cryingEventService)

    /// Service for detecting noise.
    private(set) lazy var noiseDetectionService: NoiseDetectionServiceProtocol = NoiseDetectionService()

    /// Service for detecting baby's cry
    private(set) lazy var cryingDetectionService: CryingDetectionServiceProtocol = CryingDetectionService()
    
    /// Service that takes care of appropriate controling: crying detection, audio recording.
    private(set) lazy var cryingEventService: CryingEventsServiceProtocol = CryingEventService(
        cryingDetectionService: cryingDetectionService,
        audioFileService: audioFileService)
    
    /// Service for capturing/recording microphone audio
    private(set) lazy var audioMicrophoneService: AudioMicrophoneServiceProtocol? = try? AudioMicrophoneService(microphoneFactory: AudioKitMicrophoneFactory.makeMicrophoneFactory)

    /// Service for creating, saving, and uploading audio files.
    private(set) lazy var audioFileService: AudioFileServiceProtocol = AudioFileService(storageService: storageServerService, audioFileStorage: audioFileStorage, audioBufferConverter: audioBufferConverter)

    /// Converts audio buffer to an audio file.
    private(set) lazy var audioBufferConverter: AudioBufferConvertable = AudioBufferConverter()

    /// Saves audio files.
    private(set) lazy var audioFileStorage: AudioFileStorable = AudioFileStorage()
    
    let microphonePermissionProvider: MicrophonePermissionProviderProtocol = MicrophonePermissionProvider()
    
    // MARK: - Bonjour
    
    private(set) lazy var netServiceClient: NetServiceClientProtocol = NetServiceClient(serverErrorLogger: serverErrorLogger)
    
    private(set) lazy var netServiceServer: NetServiceServerProtocol = NetServiceServer(appStateProvider: NotificationCenter.default, serverErrorLogger: serverErrorLogger)
    
    private(set) lazy var connectionChecker: ConnectionChecker = NetServiceConnectionChecker(netServiceClient: netServiceClient, urlConfiguration: urlConfiguration)
    
    // MARK: - WebRTC

    private(set) lazy var webRtcConnectionProxy: PeerConnectionProxy = RTCPeerConnectionDelegateProxy()

    private(set) lazy var webRtcServer: () -> WebRtcServerManagerProtocol = {
        WebRtcServerManager(peerConnectionFactory: self.peerConnectionFactory,
                            connectionDelegateProxy: self.webRtcConnectionProxy,
                            messageServer: self.messageServer)
    }
    
    private(set) lazy var webRtcClient: () -> WebRtcClientManagerProtocol = {
        WebRtcClientManager(
            peerConnectionFactory: self.peerConnectionFactory,
            appStateProvider: NotificationCenter.default,
            analytics: self.analytics
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
    
    lazy var webSocketEventMessageService: WebSocketEventMessageServiceProtocol = { [unowned self] in
        let messageService = WebSocketEventMessageService(
            cryingEventsRepository: self.databaseRepository,
            eventMessageConductorFactory: self.eventMessageConductorFactory)
        messageService.remoteResetObservable
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                self?.applicationResetter.reset(isRemote: true)
            })
            .disposed(by: self.bag)
        return messageService
    }()

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
    
    private (set) lazy var webSocket = ClearableLazyItem<WebSocketProtocol?> { [unowned self] in
        guard let url = self.urlConfiguration.url,
              let rawSocket = PSWebSocket.clientSocket(with: URLRequest(url: url)) else {
            return nil
        }
        let webSocket = PSWebSocketWrapper(socket: rawSocket)
        webSocket.disconnectionObservable
            .subscribe(onNext: { [weak self] in
                self?.socketCommunicationsManager.terminate()
            })
            .disposed(by: self.bag)
        webSocket.errorObservable
            .debounce(1.0, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.socketCommunicationsManager.reset()
            })
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
    
    private(set) lazy var socketCommunicationsManager: SocketCommunicationManager = DefaultSocketCommunicationManager(
        webSocketEventMessageService: webSocketEventMessageService,
        webSocketWebRtcService: webSocketWebRtcService,
        webSocket: webSocket)
    
    // MARK: - Notifications
    
    private(set) lazy var localNotificationService: NotificationServiceProtocol = NotificationService(
        networkDispatcher: networkDispatcher,
        serverKeyObtainable: serverKeyObtainable,
        analytics: analytics)
    
    private(set) lazy var networkDispatcher: NetworkDispatcherProtocol = NetworkDispatcher(
        urlSession: URLSession(configuration: .default),
        dispatchQueue: DispatchQueue(label: "NetworkDispatcherQueue"))
    
    private let serverKeyObtainable: ServerKeyObtainableProtocol = ServerKeyObtainable()
    
    private(set) var babyMonitorEventMessagesDecoder = AnyMessageDecoder<EventMessage>(EventMessageDecoder())
    
    private(set) lazy var serverService: ServerServiceProtocol = {
        let service = ServerService(
            webRtcServerManager: webRtcServer(),
            messageServer: messageServer,
            netServiceServer: netServiceServer,
            webRtcDecoders: webRtcMessageDecoders,
            soundDetectionService: soundDetectionService,
            babyModelController: databaseRepository,
            notificationsService: localNotificationService,
            babyMonitorEventMessagesDecoder: babyMonitorEventMessagesDecoder,
            analytics: analytics
        )
        service.remoteResetEventObservable
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                self?.applicationResetter.reset(isRemote: true)
            })
            .disposed(by: self.bag)
        return service
    }()
    
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
            localNotificationService: localNotificationService,
            serverService: serverService,
            analytics: analytics)
        resetter.localResetCompletionObservable
            .subscribe(onNext: { [weak self] resetCompleted in
                self?.socketCommunicationsManager.terminate()
            })
            .disposed(by: bag)
        return resetter
    }()

    /// Generator of random values.
    let randomizer: RandomGenerator = Randomizer()

    // MARK: - Analytics

    /// Application manager of analytics services.
    private(set) var analytics = AnalyticsManager()

    // MARK: - Permissions

     /// Handling permissions, which user has granted.
    private(set) var permissionsService: PermissionsProvider = PermissionsService()
}
