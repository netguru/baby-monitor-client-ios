//
//  AppDependencies.swift
//  Baby Monitor
//

import Foundation
import RealmSwift
import WebRTC
import PocketSocket

struct AppDependencies {

    private(set) lazy var netServiceClient: NetServiceClientProtocol = NetServiceClient()
    private(set) lazy var netServiceServer: NetServiceServerProtocol = NetServiceServer()
    private(set) lazy var webRtcServer: WebrtcServerManager = WebrtcServerManager()
    private(set) lazy var webRtcClient: WebrtcClientManager = WebrtcClientManager()
    private(set) var webRtcMessageDecoders: [AnyMessageDecoder<WebRtcMessage>] = [AnyMessageDecoder<WebRtcMessage>(SdpOfferDecoder()), AnyMessageDecoder<WebRtcMessage>(SdpAnswerDecoder()), AnyMessageDecoder<WebRtcMessage>(IceCandidateDecoder())]

    private(set) lazy var connectionChecker: ConnectionChecker = NetServiceConnectionChecker(netServiceClient: netServiceClient, urlConfiguration: urlConfiguration)
    
    private(set) var urlConfiguration: URLConfiguration = UserDefaultsURLConfiguration()
    /// Baby service for getting and adding babies throughout the app
    private(set) var babyRepo: BabiesRepositoryProtocol = RealmBabiesRepository(realm: try! Realm())
    private(set) var lullabiesRepo: LullabiesRepositoryProtocol = RealmLullabiesRepository(realm: try! Realm())
    
    private(set) lazy var messageServer = MessageServer(server: webSocketServer)
    private(set) lazy var webSocketServer: WebSocketServerProtocol = {
        let webSocketServer = PSWebSocketServer(host: nil, port: UInt(Constants.websocketPort))!
        return PSWebSocketServerWrapper(server: webSocketServer)
    }()
    private(set) lazy var webSocket: WebSocketProtocol? = {
        guard let url = urlConfiguration.url else {
                return nil
        }
        let urlRequest = URLRequest(url: url)
        guard let webSocket = PSWebSocket.clientSocket(with: urlRequest) else {
            return nil
        }
        return PSWebSocketWrapper(socket: webSocket)
    }()
}
