//
//  EventMessage.swift
//  Baby Monitor
//

import Foundation

enum BabyMonitorEvent: String {
    case crying = "BABY_IS_CRYING"
}

struct EventMessage: Codable {
    let action: String
    let value: String
    
    static func initWithCryingEvent(value: String) -> EventMessage {
        return EventMessage(action: BabyMonitorEvent.crying.rawValue, value: value)
    }
}
