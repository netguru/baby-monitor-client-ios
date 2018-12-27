//
//  SessionDescriptionProtocol.swift
//  Baby Monitor
//

protocol SessionDescriptionProtocol {
    var sdp: String { get }
    var stringType: String { get }
}

extension RTCSessionDescription: SessionDescriptionProtocol {
    var stringType: String {
        return type.canonicalName
    }
}
