//
//  String+WebsocketMessage.swift
//  Baby Monitor
//

protocol WebsocketMessageDecodable {
    func decode() -> String?
}

extension NSString: WebsocketMessageDecodable {
    func decode() -> String? {
        return self as String
    }
}

extension NSData: WebsocketMessageDecodable {
    func decode() -> String? {
        return String(data: self as Data, encoding: .utf8)
    }
}
