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
    private let receivedMessagePublisher = PublishRelay<String>()
    
    private let socket: PSWebSocket
    
    init(socket: PSWebSocket, assignDelegate: Bool = true) {
        self.socket = socket
        super.init()
        guard assignDelegate else {
            return
        }
        socket.delegate = self
    }
    
    func send(message: Any) {
        socket.send(message)
    }
    
    func open() {
        socket.open()
    }
    
    func close() {
        socket.close()
    }
}

extension PSWebSocketWrapper: PSWebSocketDelegate {
    
    func webSocketDidOpen(_ webSocket: PSWebSocket) {}
    
    func webSocket(_ webSocket: PSWebSocket, didFailWithError error: Error) {}
    
    func webSocket(_ webSocket: PSWebSocket, didReceiveMessage message: Any) {
        guard let messageData = message as? Data,
            let stringMessage = String(data: messageData, encoding: .utf8) else {
                return
        }
        receivedMessagePublisher.accept(stringMessage)
    }
    
    func webSocket(_ webSocket: PSWebSocket, didCloseWithCode code: Int, reason: String, wasClean: Bool) {}
}
