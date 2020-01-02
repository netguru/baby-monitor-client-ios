//
//  WebSocketServerProtocol.swift
//  Baby Monitor
//

import PocketSocket
import RxSwift
import RxCocoa

protocol WebSocketServerProtocol: WebSocketConnectionStatusProvider {
    
    /// Observable emitting connected sockets
    var connectedSocket: Observable<WebSocketProtocol> { get }
    
    /// Observable emitting disconnected sockets
    var disconnectedSocket: Observable<WebSocketProtocol> { get }
    
    /// Observable emitting received messages
    var receivedMessage: Observable<String> { get }
    
    /// Starts server
    func start()
    
    /// Stops server
    func stop()
}

final class PSWebSocketServerWrapper: NSObject, WebSocketServerProtocol {
    
    private(set) var connectionStatusObservable: Observable<WebSocketConnectionStatus>
    private var connectionStatusPublisher = PublishSubject<WebSocketConnectionStatus>()
    private let server: PSWebSocketServer
    
    var connectedSocket: Observable<WebSocketProtocol> {
        return connectedSocketPublisher.asObservable()
    }
    private let connectedSocketPublisher = PublishRelay<WebSocketProtocol>()
    
    var disconnectedSocket: Observable<WebSocketProtocol> {
        return disconnectedSocketPublisher.asObservable()
    }
    private let disconnectedSocketPublisher = PublishRelay<WebSocketProtocol>()
    
    var receivedMessage: Observable<String> {
        return receivedMessagePublisher.asObservable()
    }
    private let receivedMessagePublisher = PublishRelay<String>()
    
    init(server: PSWebSocketServer) {
        self.server = server
        self.connectionStatusObservable = connectionStatusPublisher.asObservable()
        super.init()
        server.delegate = self
    }
    
    func start() {
        server.start()
    }
    
    func stop() {
        server.stop()
    }
}

extension PSWebSocketServerWrapper: PSWebSocketServerDelegate {
    func serverDidStart(_ server: PSWebSocketServer) {
        connectionStatusPublisher.onNext(.connecting)
    }
    
    func serverDidStop(_ server: PSWebSocketServer) {
        connectionStatusPublisher.onNext(.disconnected)
    }
    
    func server(_ server: PSWebSocketServer, didFailWithError error: Error) {
        connectionStatusPublisher.onNext(.disconnected)
    }
    
    
    func server(_ server: PSWebSocketServer, webSocketDidOpen webSocket: PSWebSocket) {
        connectedSocketPublisher.accept(PSWebSocketWrapper(socket: webSocket, assignDelegate: false))
        connectionStatusPublisher.onNext(.connected)
    }
    
    func server(_ server: PSWebSocketServer, webSocket: PSWebSocket, didReceiveMessage message: Any) {
        guard let decodableMessage = message as? WebsocketMessageDecodable,
              let stringMessage = decodableMessage.decode() else {
            return
        }
        receivedMessagePublisher.accept(stringMessage)
    }
    
    func server(_ server: PSWebSocketServer, webSocket: PSWebSocket, didFailWithError error: Error) {
        connectionStatusPublisher.onNext(.disconnected)
    }
    
    func server(_ server: PSWebSocketServer, webSocket: PSWebSocket, didCloseWithCode code: Int, reason: String, wasClean: Bool) {
        disconnectedSocketPublisher.accept(PSWebSocketWrapper(socket: webSocket, assignDelegate: false))
        connectionStatusPublisher.onNext(.disconnected)
    }
}
