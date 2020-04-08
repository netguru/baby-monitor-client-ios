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
        return type.string
    }
}

extension RTCSdpType {
    var string: String {
        switch self {
        case .answer:
            return "answer"
        case .offer:
            return "offer"
        case .prAnswer:
            return "prAnswer"
        @unknown default:
            assertionFailure("The case had not been handled.")
            return ""
        }
    }

    static func type(for string: String) -> RTCSdpType? {
        switch string {
        case "answer":
            return .answer
        case "offer":
            return .offer
        case "prAnswer":
            return .prAnswer
        default:
            return nil
        }
    }
}
