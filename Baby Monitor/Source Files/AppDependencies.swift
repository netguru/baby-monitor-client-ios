//
//  AppDependencies.swift
//  Baby Monitor
//

import Foundation
import RealmSwift
import PocketSocket
import AudioKit
import FirebaseMessaging

final class AppDependencies {
    
    /// Service for cleaning too many crying events
    private(set) lazy var memoryCleaner: MemoryCleanerProtocol = MemoryCleaner()
    /// Service for recording audio
    private(set) lazy var audioRecordService: AudioRecordServiceProtocol? = try? AudioRecordService(recorderFactory: AudioKitRecorderFactory.makeRecorderFactory)
    /// Service for detecting baby's cry
    private(set) lazy var cryingDetectionService: CryingDetectionServiceProtocol = CryingDetectionService(microphoneTracker: AKMicrophoneTracker())
    /// Service that takes care of appropriate controling: crying detection, audio recording and saving these events to realm database
    private(set) lazy var cryingEventService: CryingEventsServiceProtocol = CryingEventService(cryingDetectionService: cryingDetectionService, audioRecordService: audioRecordService, babiesRepository: babiesRepository)

    private(set) lazy var netServiceClient: () -> NetServiceClientProtocol = { NetServiceClient() }
    private(set) lazy var netServiceServer: NetServiceServerProtocol = NetServiceServer()
    private(set) lazy var peerConnectionFactory: PeerConnectionFactoryProtocol = RTCPeerConnectionFactory()
    private(set) lazy var webRtcServer: () -> WebRtcServerManagerProtocol = {
        let peerConnectionDelegateProxy = PeerConnectionDelegateProxy()
        let sessionDescriptionDelegateProxy = SessionDescriptionDelegateProxy()
        let serverManager = WebRtcServerManager(peerConnectionFactory: self.peerConnectionFactory, connectionDelegateProxy: peerConnectionDelegateProxy, sessionDelegateProxy: sessionDescriptionDelegateProxy)
        peerConnectionDelegateProxy.delegate = serverManager
        sessionDescriptionDelegateProxy.delegate = serverManager
        return serverManager
    }
    private(set) lazy var webRtcClient: () -> WebRtcClientManagerProtocol = {
        let peerConnectionDelegateProxy = PeerConnectionDelegateProxy()
        let sessionDescriptionDelegateProxy = SessionDescriptionDelegateProxy()
        let clientManager = WebRtcClientManager(peerConnectionFactory: self.peerConnectionFactory, connectionDelegateProxy: peerConnectionDelegateProxy, sessionDelegateProxy: sessionDescriptionDelegateProxy)
        peerConnectionDelegateProxy.delegate = clientManager
        sessionDescriptionDelegateProxy.delegate = clientManager
        return clientManager
    }
    private(set) lazy var websocketsService: WebSocketsServiceProtocol = WebSocketsService(
        webRtcClientManager: webRtcClient(),
        webSocket: webSocket(urlConfiguration.url),
        cryingEventsRepository: babiesRepository,
        webRtcMessageDecoders: webRtcMessageDecoders,
        babyMonitorEventMessagesDecoder: babyMonitorEventMessagesDecoder)
    private(set) lazy var networkDispatcher: NetworkDispatcherProtocol = NetworkDispatcher()
    private(set) lazy var localNotificationService: NotificationServiceProtocol = NotificationService(
        networkDispatcher: networkDispatcher,
        cacheService: cacheService,
        serverKeyObtainable: serverKeyObtainable)
    private let serverKeyObtainable: ServerKeyObtainableProtocol = ServerKeyObtainable()
    
    private(set) var webRtcMessageDecoders: [AnyMessageDecoder<WebRtcMessage>] = [AnyMessageDecoder<WebRtcMessage>(SdpOfferDecoder()), AnyMessageDecoder<WebRtcMessage>(SdpAnswerDecoder()), AnyMessageDecoder<WebRtcMessage>(IceCandidateDecoder())]
    
    private(set) var babyMonitorEventMessagesDecoder = AnyMessageDecoder<EventMessage>(EventMessageDecoder())
    private(set) var cacheService: CacheServiceProtocol = CacheService()

    private(set) lazy var connectionChecker: ConnectionChecker = NetServiceConnectionChecker(netServiceClient: netServiceClient(), urlConfiguration: urlConfiguration)
    private(set) lazy var clientService: ClientServiceProtocol = ClientService(websocketsService: websocketsService, localNotificationService: localNotificationService, messageServer: messageServer)
    private(set) lazy var serverService: ServerServiceProtocol = ServerService(
        webRtcServerManager: webRtcServer(),
        messageServer: messageServer,
        netServiceServer: netServiceServer,
        webRtcDecoders: webRtcMessageDecoders,
        cryingService: cryingEventService,
        babiesRepository: babiesRepository,
        websocketsService: websocketsService,
        cacheService: cacheService,
        notificationsService: localNotificationService,
        babyMonitorEventMessagesDecoder: babyMonitorEventMessagesDecoder
    )
    
    private(set) var urlConfiguration: URLConfiguration = UserDefaultsURLConfiguration()
    private(set) lazy var messageServer = MessageServer(server: webSocketServer)
    private(set) lazy var webSocketServer: WebSocketServerProtocol = {
        let webSocketServer = PSWebSocketServer(host: nil, port: UInt(Constants.websocketPort))!
        return PSWebSocketServerWrapper(server: webSocketServer)
    }()
    private(set) lazy var webSocket: (URL?) -> WebSocketProtocol? = { url in
        guard let url = url else {
            return nil
        }
        let urlRequest = URLRequest(url: url)
        guard let webSocket = PSWebSocket.clientSocket(with: urlRequest) else {
            return nil
        }
        return PSWebSocketWrapper(socket: webSocket)
    }
    /// Baby service for getting and adding babies throughout the app
    private(set) lazy var babiesRepository: BabiesRepositoryProtocol & CryingEventsRepositoryProtocol = RealmBabiesRepository(realm: try! Realm())
    private(set) lazy var lullabiesRepository: LullabiesRepositoryProtocol = RealmLullabiesRepository(realm: try! Realm())
    /// Service for handling errors and showing error alerts
    private(set) var errorHandler: ErrorHandlerProtocol = ErrorHandler()
}
