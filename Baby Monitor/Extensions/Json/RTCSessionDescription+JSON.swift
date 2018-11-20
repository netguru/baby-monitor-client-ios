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

    static func type(from canonicalName: String) -> RTCSdpType? {
        switch canonicalName {
        case "answer":
            return .answer
        case "offer":
            return .offer
        case "pranswer":
            return .prAnswer
        default:
            return nil
        }
    }
}

private enum Keys: String {
    case type
    case sdp
}

extension SessionDescriptionProtocol {
    func jsonDictionary() -> [AnyHashable: Any] {
        return [Keys.type.rawValue: stringType,
                Keys.sdp.rawValue: sdp]
    }
}

extension RTCSessionDescription {
    convenience init?(dictionary: [AnyHashable: Any]) {
        guard let typeString = dictionary[Keys.type.rawValue] as? String,
            let type = RTCSdpType.type(from: typeString),
            let sdp = dictionary[Keys.sdp.rawValue] as? String else {
                return nil
        }
        self.init(type: type, sdp: sdp)
    }
}
