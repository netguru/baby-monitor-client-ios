//
//  RTCIceCandidate+JSON.swift
//  Baby Monitor
//

extension IceCandidateProtocol {
    func jsonDictionary() -> [AnyHashable: Any] {
        return ["type": "candidate",
                "label": sdpMLineIndex,
                "id": sdpMid,
                "candidate": sdp]
    }
}

extension RTCICECandidate {
    convenience init?(dictionary: [AnyHashable: Any]) {
        guard dictionary["type"] as? String == "candidate",
            let label = dictionary["label"] as? Int,
            let id = dictionary["id"] as? String,
            let candidate = dictionary["candidate"] as? String else {
                return nil
        }
        self.init(mid: id, index: label, sdp: candidate)
    }
}
