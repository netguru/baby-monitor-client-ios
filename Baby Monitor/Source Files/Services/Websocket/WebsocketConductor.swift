//
//  WebsocketConductor.swift
//  Baby Monitor
//

import RxSwift

protocol WebSocketConductorProtocol {
    func open()
}

final class WebSocketConductor<MessageType>: WebSocketConductorProtocol {

    private let webSocket: WebSocketProtocol?
    private let messageEmitter: Observable<String>
    private let messageHandler: AnyObserver<MessageType>
    private let messageDecoders: [AnyMessageDecoder<MessageType>]
    private let bag = DisposeBag()

    init(webSocket: WebSocketProtocol?, messageEmitter: Observable<String>, messageHandler: AnyObserver<MessageType>, messageDecoders: [AnyMessageDecoder<MessageType>]) {
        self.webSocket = webSocket
        self.messageEmitter = messageEmitter
        self.messageHandler = messageHandler
        self.messageDecoders = messageDecoders
        setup()
    }

    private func setup() {
        self.messageEmitter
            .subscribe(onNext: { [weak self] json in
                self?.webSocket?.send(message: json)
            })
            .disposed(by: bag)
        webSocket?.decodedMessage(using: messageDecoders)
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: messageHandler)
            .disposed(by: bag)
    }

    func open() {
        self.webSocket?.open()
    }
}
