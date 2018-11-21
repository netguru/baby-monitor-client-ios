//
//  AnyMessageDecoder.swift
//  Baby Monitor
//

final class AnyMessageDecoder<ConcreteType>: MessageDecoderProtocol {

    typealias T = ConcreteType
    
    init<MessageDecoder: MessageDecoderProtocol>(_ messageDecoder: MessageDecoder) where MessageDecoder.T == ConcreteType {
        _decode = messageDecoder.decode
    }
    
    private let _decode: (String) -> ConcreteType?
    
    func decode(message: String) -> ConcreteType? {
        return _decode(message)
    }
}
