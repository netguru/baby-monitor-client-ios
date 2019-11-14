//
//  RTCIceCandidate+JSON.swift
//  Baby Monitor
//

import WebRTC

extension IceCandidateProtocol {
    func jsonDictionary() -> [AnyHashable: Any] {
        return ["type": "candidate",
                "label": sdpMLineIndex,
                "id": sdpMid ?? "",
                "candidate": sdp]
    }
}

extension RTCIceCandidate {
    convenience init?(dictionary: [AnyHashable: Any]) {
        guard dictionary["type"] as? String == "candidate",
            let label = dictionary["label"] as? Int,
            let id = dictionary["id"] as? String,
            let candidate = dictionary["candidate"] as? String else {
                return nil
        }
        self.init(sdp: candidate, sdpMLineIndex: Int32(label), sdpMid: id)
    }
}
