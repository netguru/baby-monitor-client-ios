//
//  String+WebsocketMessage.swift
//  Baby Monitor
//

extension String {
    static func from(websocketMessage: Any) -> String? {
        if let stringMessage = websocketMessage as? String {
            return stringMessage
        }
        if let messageData = websocketMessage as? Data {
            return String(data: messageData, encoding: .utf8)
        }
        return nil
    }
}
