//
//  WebsocketServer.swift
//  Baby Monitor
//

import PocketSocket
import RxCocoa
import RxSwift

private extension WebSocketProtocol {
    func id() -> WebSocketProtocol {
        return self
    }
}

final class MessageServer: NSObject, MessageServerProtocol {
    
    private let server: WebSocketServerProtocol
    private let client = BehaviorRelay<WebSocketProtocol?>(value: nil)
    private let bag = DisposeBag()
    let receivedMessage: Observable<String>
    private(set) var connectionStatusObservable: Observable<WebSocketConnectionStatus>
    
    init(server: WebSocketServerProtocol) {
        self.server = server
        self.receivedMessage = server.receivedMessage
        self.connectionStatusObservable = server.connectionStatusObservable
        super.init()
        setup()
    }
    
    private func setup() {
        let disconnectedSocket: Observable<WebSocketProtocol?> = server.disconnectedSocket.map { _ in nil }
        let connectedSocket: Observable<WebSocketProtocol?> = server.connectedSocket.map { $0.id() }
        Observable.merge(disconnectedSocket, connectedSocket)
            .bind(to: client)
            .disposed(by: bag)
    }
    
    func send(message: String) {
        client.value?.send(message: message)
    }
    
    func start() {
        server.start()
    }
    
    func stop() {
        server.stop()
    }
}
