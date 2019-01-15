//
//  String+WebsocketMessage.swift
//  Baby Monitor
//

protocol WebsocketMessageDecodable {
    func decode() -> String?
}

extension String: WebsocketMessageDecodable {
    func decode() -> String? {
        return self
    }
}

extension Data: WebsocketMessageDecodable {
    func decode() -> String? {
        return String(data: self, encoding: .utf8)
    }
}
