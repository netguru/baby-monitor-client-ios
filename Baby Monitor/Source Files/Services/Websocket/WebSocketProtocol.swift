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

    private enum ConnectionState {
        case disconnected
        case connecting
        case connected
    }
    
    let dispatchQueue = DispatchQueue(label: "webRTCQueue", qos: DispatchQoS.userInteractive)
    
    lazy var disconnectionObservable = disconnectionPublisher.asObservable()
    private var disconnectionPublisher = PublishSubject<Void>()
    
    var receivedMessage: Observable<String> {
        return receivedMessagePublisher.observeOn(ConcurrentDispatchQueueScheduler(queue: dispatchQueue)).subscribeOn(ConcurrentDispatchQueueScheduler(queue: dispatchQueue))
    }

    private let receivedMessagePublisher = PublishRelay<String>()
    private let socket: PSWebSocket

    private var buffer: [Any] = []

    private var connectionState = ConnectionState.disconnected {
        didSet {
            switch connectionState {
            case .disconnected:
                disconnectionPublisher.onNext(())
            default:
                break
            }
        }
    }
    
    init(socket: PSWebSocket, assignDelegate: Bool = true) {
        self.socket = socket
        super.init()
        guard assignDelegate else {
            connectionState = .connected
            return
        }
        socket.delegate = self
    }
    
    func send(message: Any) {
        if connectionState == .connected {
            socket.send(message)
        } else {
            buffer.append(message)
        }
    }
    
    func open() {
        guard connectionState == .disconnected && (socket.readyState == .connecting) else {
            return
        }
        connectionState = .connecting
        socket.open()
    }
    
    func close() {
        guard connectionState == .connected else {
            return
        }
        socket.close()
    }
}

extension PSWebSocketWrapper: PSWebSocketDelegate {
    
    func webSocketDidOpen(_ webSocket: PSWebSocket) {
        buffer.forEach { webSocket.send($0) }
        connectionState = .connected
        buffer = []
    }
    
    func webSocket(_ webSocket: PSWebSocket, didFailWithError error: Error?) {
        connectionState = .disconnected
    }
    
    func webSocket(_ webSocket: PSWebSocket, didReceiveMessage message: Any) {
        guard let decodableMessage = message as? WebsocketMessageDecodable,
            let stringMessage = decodableMessage.decode() else {
            return
        }
        receivedMessagePublisher.accept(stringMessage)
    }
    
    func webSocket(_ webSocket: PSWebSocket, didCloseWithCode code: Int, reason: String, wasClean: Bool) {
        connectionState = .disconnected
    }
}
