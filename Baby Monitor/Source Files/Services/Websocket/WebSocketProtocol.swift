//
//  WebSocketProtocol.swift
//  Baby Monitor
//

import PocketSocket
import RxSwift
import RxCocoa

protocol WebSocketProtocol: MessageStreamProtocol, WebSocketConnectionStatusProvider {
    
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

    private enum ConnectionState: Equatable {
        case disconnected
        case connecting
        case connected
        case error(NSError)
    
        static func ==(lhs: ConnectionState, rhs: ConnectionState) -> Bool {
            switch (lhs, rhs) {
            case (.disconnected, .disconnected),
                 (.connecting, .connecting),
                 (.connected, .connected):
                return true
            case let (.error(lhsError), .error(rhsError)):
                return lhsError == rhsError
            default:
                return false
            }
        }
        
        func toWebSocketConnectionStatus() -> WebSocketConnectionStatus {
            switch self {
            case .connected:
                return .connected
            case .connecting:
                return .connecting
            default:
                return .disconnected
            }
        }
    }
    
    let dispatchQueue = DispatchQueue(label: "webRTCQueue", qos: DispatchQoS.userInteractive)
    
    private(set) lazy var disconnectionObservable = disconnectionPublisher.asObservable()
    private(set) lazy var connectionStatusObservable: Observable<WebSocketConnectionStatus> = connectionStatusPublisher.asObservable()
    lazy var errorObservable = errorPublisher.asObservable()
    private var disconnectionPublisher = PublishSubject<Void>()
    private var errorPublisher = PublishSubject<Error>()
    private var connectionStatusPublisher = PublishSubject<WebSocketConnectionStatus>()
    
    var receivedMessage: Observable<String> {
        return receivedMessagePublisher.observeOn(ConcurrentDispatchQueueScheduler(queue: dispatchQueue)).subscribeOn(ConcurrentDispatchQueueScheduler(queue: dispatchQueue))
    }

    private let receivedMessagePublisher = PublishRelay<String>()
    private let socket: PSWebSocket

    private var buffer: [Any] = []

    private var connectionState = ConnectionState.disconnected {
        didSet {
            switch connectionState {
            case .error(let error):
                errorPublisher.onNext(error)
            case .disconnected:
                disconnectionPublisher.onNext(())
            default:
                break
            }
            connectionStatusPublisher.onNext(connectionState.toWebSocketConnectionStatus())
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
        reopen()
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
        buffer.forEach {
            webSocket.send($0)
        }
        connectionState = .connected
        buffer = []
    }
    
    func webSocket(_ webSocket: PSWebSocket, didFailWithError error: Error?) {
        if let error = error as NSError? {
            connectionState = .error(error)
        } else {
            connectionState = .disconnected
        }
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
        if !wasClean {
            webSocket.close()
            reopen()
        }
    }
}

private extension PSWebSocketWrapper {
    
    func reopen() {
        connectionState = .connecting
        socket.open()
    }
}
