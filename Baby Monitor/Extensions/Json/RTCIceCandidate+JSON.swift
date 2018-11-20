//
//  RTCIceCandidate+JSON.swift
//  Baby Monitor
//

import WebRTC

private enum Keys: String {
    case type
    case candidate
    case label
    case id
}

extension IceCandidateProtocol {

    func jsonDictionary() -> [AnyHashable: Any] {
        return [Keys.type.rawValue: Keys.candidate.rawValue,
                Keys.label.rawValue: sdpMLineIndex,
                Keys.id.rawValue: sdpMid ?? "",
                Keys.candidate.rawValue: sdp]
    }
}

extension RTCIceCandidate {
    convenience init?(dictionary: [AnyHashable: Any]) {
        guard dictionary[Keys.type.rawValue] as? String == Keys.candidate.rawValue,
            let label = dictionary[Keys.label.rawValue] as? Int,
            let id = dictionary[Keys.id.rawValue] as? String,
            let candidate = dictionary[Keys.candidate.rawValue] as? String else {
                return nil
        }
        self.init(sdp: candidate, sdpMLineIndex: Int32(label), sdpMid: id)
    }
}
