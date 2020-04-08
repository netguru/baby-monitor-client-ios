//
//  MessageStream.swift
//  Baby Monitor
//

import RxSwift

protocol MessageStreamProtocol: AnyObject {
    
    /// Observable emitting received messages
    var receivedMessage: Observable<String> { get }
    
    /// Converts received messages to decoded messages
    ///
    /// - Parameter decoders: Decoders used to decode message
    /// - Returns: Observable emitting messages decoded with one of the decoders. If none fit, nil is returned
    func decodedMessage<T>(using decoders: [AnyMessageDecoder<T>]) -> Observable<T?>
}

extension MessageStreamProtocol {
    func decodedMessage<T>(using decoders: [AnyMessageDecoder<T>]) -> Observable<T?> {
        return receivedMessage.map { message in
            return decoders.compactMap { $0.decode(message: message) }.first
        }
    }
}
