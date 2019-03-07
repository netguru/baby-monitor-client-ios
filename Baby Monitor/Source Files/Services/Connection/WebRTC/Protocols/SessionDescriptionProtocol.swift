//
//  SessionDescriptionProtocol.swift
//  Baby Monitor
//

protocol SessionDescriptionProtocol {
    var sdp: String { get }
    var stringType: String { get }
}

extension RTCSessionDescription: SessionDescriptionProtocol {
    var sdp: String {
        return self.description
    }
    
    var stringType: String {
        return type ?? ""
    }
}
