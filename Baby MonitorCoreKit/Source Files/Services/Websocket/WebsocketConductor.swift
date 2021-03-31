//
//  WebsocketConductor.swift
//  Baby Monitor
//

import PocketSocket
import RxSwift

protocol WebSocketConductorProtocol: WebSocketConnectionStatusProvider {
    func open()
    func close()
}

final class WebSocketConductor<MessageType>: WebSocketConductorProtocol {

    enum WebSocketError: Error {
        case noSocket
    }

    var connectionStatusObservable: Observable<WebSocketConnectionStatus> {
        guard let webSocket = webSocket else {
            assertionFailure()
            return Observable.error(WebSocketError.noSocket)
        }
        return webSocket.connectionStatusObservable
    }

    private let messageEmitter: Observable<String>
    private let messageHandler: AnyObserver<MessageType>?
    private let messageDecoders: [AnyMessageDecoder<MessageType>]
    private let bag = DisposeBag()

    private let webSocketStorage: ClearableLazyItem<WebSocketProtocol?>
    private var webSocket: WebSocketProtocol? {
        return webSocketStorage.get()
    }

    init(webSocket: ClearableLazyItem<WebSocketProtocol?>, messageEmitter: Observable<String>, messageHandler: AnyObserver<MessageType>?, messageDecoders: [AnyMessageDecoder<MessageType>]) {
        self.webSocketStorage = webSocket
        self.messageEmitter = messageEmitter
        self.messageHandler = messageHandler
        self.messageDecoders = messageDecoders
        setup()
    }

    private func setup() {
        self.messageEmitter
            .subscribe(onNext: { [unowned self] in self.webSocket?.send(message: $0) })
            .disposed(by: bag)
    }

    func open() {
        webSocket?.open()
        guard let messageHandler = messageHandler else {
            return
        }
        webSocket?.decodedMessage(using: messageDecoders)
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: messageHandler)
            .disposed(by: bag)
    }

    func close() {
        webSocket?.close()
    }
    
}
