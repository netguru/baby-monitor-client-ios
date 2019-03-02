//
//  WebsocketConductor.swift
//  Baby Monitor
//

import PocketSocket
import RxSwift

protocol WebSocketConductorProtocol {
    func open()
    func close()
}

final class WebSocketConductor<MessageType>: WebSocketConductorProtocol {

    private let urlConfiguration: URLConfiguration
    private var webSocket: WebSocketProtocol?
    private let messageEmitter: Observable<String>
    private let messageHandler: AnyObserver<MessageType>
    private let disconnectionHandler: AnyObserver<Void>
    private let messageDecoders: [AnyMessageDecoder<MessageType>]
    private let bag = DisposeBag()

    init(urlConfiguration: URLConfiguration, messageEmitter: Observable<String>, messageHandler: AnyObserver<MessageType>, disconnectionHandler: AnyObserver<Void>, messageDecoders: [AnyMessageDecoder<MessageType>]) {
        self.urlConfiguration = urlConfiguration
        self.messageEmitter = messageEmitter
        self.messageHandler = messageHandler
        self.disconnectionHandler = disconnectionHandler
        self.messageDecoders = messageDecoders
        setup()
    }

    private func setup() {
        self.messageEmitter
            .subscribe(onNext: { [weak self] in self?.webSocket?.send(message: $0) })
            .disposed(by: bag)
    }

    func open() {

        guard let url = urlConfiguration.url else { return }
        guard let rawSocket = PSWebSocket.clientSocket(with: URLRequest(url: url)) else { return }

        webSocket = PSWebSocketWrapper(socket: rawSocket)

        webSocket!.decodedMessage(using: messageDecoders)
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: messageHandler)
            .disposed(by: bag)

        webSocket!.disconnectionObservable
            .bind(to: disconnectionHandler)
            .disposed(by: bag)

        webSocket?.open()

    }

    func close() {
        webSocket?.close()
        webSocket = nil
    }
    
}
