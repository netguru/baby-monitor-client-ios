//
//  WebsocketServerProtocol.swift
//  Baby Monitor
//

import RxSwift

protocol MessageServerProtocol: MessageStreamProtocol, WebSocketConnectionStatusProvider {
    
    /// Sends message to connected client
    ///
    /// - Parameter message: message to be send
    func send(message: String)
    
    /// Starts server
    func start()
    
    /// Stops server
    func stop()
}
