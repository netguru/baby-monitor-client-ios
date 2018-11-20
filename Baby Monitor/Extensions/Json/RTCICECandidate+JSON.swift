//
//  RTCIceCandidate+JSON.swift
//  Baby Monitor
//

import WebRTC

extension RTCIceCandidate {

    private enum Keys: String {
        case type
        case candidate
        case label
        case id
    }

    func jsonDictionary() -> [AnyHashable: Any] {
        return [RTCIceCandidate.Keys.type.rawValue: RTCIceCandidate.Keys.candidate.rawValue,
                RTCIceCandidate.Keys.label.rawValue: sdpMLineIndex,
                RTCIceCandidate.Keys.id.rawValue: sdpMid ?? "",
                RTCIceCandidate.Keys.candidate.rawValue: sdp]
    }
    
    convenience init?(dictionary: [AnyHashable: Any]) {
        guard dictionary[RTCIceCandidate.Keys.type.rawValue] as? String == RTCIceCandidate.Keys.candidate.rawValue,
            let label = dictionary[RTCIceCandidate.Keys.label.rawValue] as? Int,
            let id = dictionary[RTCIceCandidate.Keys.id.rawValue] as? String,
            let candidate = dictionary[RTCIceCandidate.Keys.candidate.rawValue] as? String else {
                return nil
        }
        self.init(sdp: candidate, sdpMLineIndex: Int32(label), sdpMid: id)
    }
}
