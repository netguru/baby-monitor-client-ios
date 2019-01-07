//
//  RTCSessionDescription+JSON.swift
//  Baby Monitor
//

private enum Keys: String {
    case type
    case sdp
}

extension RTCSessionDescription {
    func jsonDictionary() -> [AnyHashable: Any] {
        return [Keys.type.rawValue: type,
                Keys.sdp.rawValue: description]
    }
    
    convenience init?(dictionary: [AnyHashable: Any]) {
        guard let type = dictionary[Keys.type.rawValue] as? String,
            let description = dictionary[Keys.sdp.rawValue] as? String else {
                return nil
        }
        self.init(type: type, sdp: description)
    }
}
