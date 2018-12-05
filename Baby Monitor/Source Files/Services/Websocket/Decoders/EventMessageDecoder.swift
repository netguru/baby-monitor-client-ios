//
//  EventMessageDecoder.swift
//  Baby Monitor
//

import Foundation

final class EventMessageDecoder: MessageDecoderProtocol {
    
    typealias T = BabyMonitorEvent
    
    func decode(message: String) -> BabyMonitorEvent? {
        guard let data = message.data(using: .utf16),
            let eventMessage = try? JSONDecoder().decode(EventMessage.self, from: data),
            let babyMonitorEvent = BabyMonitorEvent(rawValue: eventMessage.action) else {
                return nil
        }
        return babyMonitorEvent
    }
}
