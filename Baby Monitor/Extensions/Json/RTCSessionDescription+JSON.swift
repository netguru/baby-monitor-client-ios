//
//  RTCSessionDescription+JSON.swift
//  Baby Monitor
//

import WebRTC

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
        guard let type = dictionary[Keys.type.rawValue] as? String,
            let sdpType = RTCSdpType.type(for: type),
            let description = dictionary[Keys.sdp.rawValue] as? String else {
                return nil
        }
        self.init(type: sdpType, sdp: description)
    }
}
