//
//  EventMessage.swift
//  Baby Monitor
//

import Foundation

enum BabyMonitorEvent: String {
    case crying = "BABY_IS_CRYING"
    case cryingEventMessageReceived = "CRYING_EVENT_MESSAGE_RECEIVED"
    case pushNotificationsKey = "PUSH_NOTIFICATIONS_KEY"
}

struct EventMessage: Codable {
    let action: String
    let value: String
    
    static func initWithCryingEvent(value: String) -> EventMessage {
        return EventMessage(action: BabyMonitorEvent.crying.rawValue, value: value)
    }
    
    static func initWithMessageReceived() -> EventMessage {
        return EventMessage(action: BabyMonitorEvent.cryingEventMessageReceived.rawValue, value: "")
    }
    
    static func initWithPushNotificationsKey(key: String) -> EventMessage {
        return EventMessage(action: BabyMonitorEvent.pushNotificationsKey.rawValue, value: key)
    }
}
