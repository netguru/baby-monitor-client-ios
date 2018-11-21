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
        return RTCSdpType.allCases.first { $0.canonicalName == canonicalName }
    }

    static let allCases: [RTCSdpType] = [.answer, .offer, .prAnswer]
}

extension RTCSessionDescription {
    private enum Keys: String {
        case type
        case sdp
    }

    func jsonDictionary() -> [AnyHashable: Any] {
        return [RTCSessionDescription.Keys.type.rawValue: type.canonicalName,
                RTCSessionDescription.Keys.sdp.rawValue: sdp]
    }
    
    convenience init?(dictionary: [AnyHashable: Any]) {
        guard let typeString = dictionary[RTCSessionDescription.Keys.type.rawValue] as? String,
            let type = RTCSdpType.type(from: typeString),
            let sdp = dictionary[RTCSessionDescription.Keys.sdp.rawValue] as? String else {
                return nil
        }
        self.init(type: type, sdp: sdp)
    }
}
