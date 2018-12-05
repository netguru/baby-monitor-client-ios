//
//  EventMessageDecoder.swift
//  Baby Monitor
//

import Foundation

final class EventMessageDecoder: MessageDecoderProtocol {
    
    typealias T = EventMessage
    
    func decode(message: String) -> EventMessage? {
        guard let data = message.data(using: .utf16),
            let eventMessage = try? JSONDecoder().decode(EventMessage.self, from: data) else {
                return nil
        }
        return eventMessage
    }
}
