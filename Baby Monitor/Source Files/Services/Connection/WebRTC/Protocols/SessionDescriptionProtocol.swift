//
//  SessionDescriptionProtocol.swift
//  Baby Monitor
//

import WebRTC

protocol SessionDescriptionProtocol {
    var sdp: String { get }
    var stringType: String { get }
}

extension RTCSessionDescription: SessionDescriptionProtocol {
    var stringType: String {
        return type.canonicalName
    }
}
