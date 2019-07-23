//
//  WebSocketProtocol.swift
//  Baby Monitor
//

import PocketSocket
import RxSwift
import RxCocoa

protocol WebSocketProtocol: MessageStreamProtocol {
    
    var disconnectionObservable: Observable<Void> { get }
    
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
    
    let dispatchQueue = DispatchQueue(label: "webRTCQueue", qos: DispatchQoS.userInteractive)
    
    lazy var disconnectionObservable = disconnectionPublisher.asObservable()
    private var disconnectionPublisher = PublishSubject<Void>()
    
    var receivedMessage: Observable<String> {
        return receivedMessagePublisher.observeOn(ConcurrentDispatchQueueScheduler(queue: dispatchQueue)).subscribeOn(ConcurrentDispatchQueueScheduler(queue: dispatchQueue))
    }
    
    private var isConnected = false {
        didSet {
            if !isConnected {
                disconnectionPublisher.onNext(())
            }
        }
    }
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
        guard !isConnected else {
            return
        }
        socket.open()
    }
    
    func close() {
        guard isConnected else {
            return
        }
        socket.close()
    }
}

extension PSWebSocketWrapper: PSWebSocketDelegate {
    
    func webSocketDidOpen(_ webSocket: PSWebSocket) {
        buffer.forEach { webSocket.send($0) }
        isConnected = true
        buffer = []
    }
    
    func webSocket(_ webSocket: PSWebSocket, didFailWithError error: Error) {
        isConnected = false
    }
    
    func webSocket(_ webSocket: PSWebSocket, didReceiveMessage message: Any) {
        guard let decodableMessage = message as? WebsocketMessageDecodable,
            let stringMessage = decodableMessage.decode() else {
            return
        }
        receivedMessagePublisher.accept(stringMessage)
    }
    
    func webSocket(_ webSocket: PSWebSocket, didCloseWithCode code: Int, reason: String, wasClean: Bool) {
        isConnected = false
    }
}
