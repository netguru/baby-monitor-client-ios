//
//  Encodable+StringMessage.swift
//  Baby Monitor
//

import Foundation

extension Encodable {
    
    func toStringMessage() -> String {
        guard
            let data = try? JSONEncoder().encode(self),
            let stringMessage = String(data: data, encoding: .utf8)
        else {
            fatalError("Could not change to string message")
        }
        return stringMessage
    }
}
