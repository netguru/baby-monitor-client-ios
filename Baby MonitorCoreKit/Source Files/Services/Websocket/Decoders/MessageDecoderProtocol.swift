//
//  MessageDecoderProtocol.swift
//  Baby Monitor
//

protocol MessageDecoderProtocol {
    associatedtype T
    
    func decode(message: String) -> T?
}
