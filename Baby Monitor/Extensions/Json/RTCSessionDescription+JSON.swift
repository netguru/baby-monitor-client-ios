//
//  RTCSessionDescription+JSON.swift
//  Baby Monitor
//

import WebRTC

extension RTCSessionDescription {
    
    func jsonDictionary() -> [AnyHashable: Any] {
        return ["type": type,
                "sdp": description]
    }
    
    convenience init?(dictionary: [AnyHashable: Any]) {
        guard let type = dictionary["type"] as? String,
            let sdp = dictionary["sdp"] as? String else {
                return nil
        }
        self.init(type: type, sdp: sdp)
    }
}
