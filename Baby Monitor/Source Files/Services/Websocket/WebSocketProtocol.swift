//
//  WebSocketProtocol.swift
//  Baby Monitor
//

import PocketSocket
import RxSwift
import RxCocoa

protocol WebSocketProtocol: MessageStreamProtocol {
    
    /// Sends message to connected socket
    ///
    /// - Parameter message: Message to be send
    func send(message: Any)
    
    /// Opens the connection
    func open()
    
    /// Closes the connection
    func close()
}

final class PSWebSocketWrapper: NSObject, WebSocketProtocol {
    
    var receivedMessage: Observable<String> {
        return receivedMessagePublisher.asObservable()
    }
    
    private var isConnected = false
    private let receivedMessagePublisher = PublishRelay<String>()
    private let socket: PSWebSocket

    private var buffer: [Any] = []
    
    init(socket: PSWebSocket, assignDelegate: Bool = true) {
        self.socket = socket
        super.init()
        guard assignDelegate else {
            isConnected = true
            return
        }
        socket.delegate = self
    }
    
    func send(message: Any) {
        if isConnected {
            socket.send(message)
        } else {
            buffer.append(message)
        }
    }
    
    func open() {
        socket.open()
    }
    
    func close() {
        socket.close()
    }
}

extension PSWebSocketWrapper: PSWebSocketDelegate {
    
    func webSocketDidOpen(_ webSocket: PSWebSocket) {
        buffer.forEach { webSocket.send($0) }
        isConnected = true
        buffer = []
    }
    
    func webSocket(_ webSocket: PSWebSocket, didFailWithError error: Error) {}
    
    func webSocket(_ webSocket: PSWebSocket, didReceiveMessage message: Any) {
        if let stringMessage = message as? String {
            receivedMessagePublisher.accept(stringMessage)
        }
        if let messageData = message as? Data,
            let stringMessage = String(bytes: messageData, encoding: .utf8) {
            receivedMessagePublisher.accept(stringMessage)
        }
    }
    
    func webSocket(_ webSocket: PSWebSocket, didCloseWithCode code: Int, reason: String, wasClean: Bool) {}
}
