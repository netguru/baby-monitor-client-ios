//
//  RTCSessionDescription+JSON.swift
//  Baby Monitor
//

import WebRTC

extension RTCSdpType {
    var canonicalName: String {
        switch self {
        case .answer:
            return "answer"
        case .offer:
            return "offer"
        case .prAnswer:
            return "pranswer"
        }
    }
}

extension RTCSdpType {

    static func type(from canonicalName: String) -> RTCSdpType? {
        switch canonicalName {
        case "answer":
            return .answer
        case "offer":
            return .offer
        default:
            return nil
        }
    }
}

extension RTCSessionDescription {
    
    func jsonDictionary() -> [AnyHashable: Any] {
        return ["type": type.canonicalName,
                "sdp": sdp]
    }
    
    convenience init?(dictionary: [AnyHashable: Any]) {
        guard let typeString = dictionary["type"] as? String,
            let type = RTCSdpType.type(from: typeString),
            let sdp = dictionary["sdp"] as? String else {
                return nil
        }
        self.init(type: type, sdp: sdp)
    }
}
