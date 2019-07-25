//
//  EventMessage.swift
//  Baby Monitor
//

import Foundation

enum BabyMonitorEvent: String {
    case pushNotificationsKey = "PUSH_NOTIFICATIONS_KEY"
}

struct EventMessage: Codable {
    let action: String
    let value: String
    
    static func initWithPushNotificationsKey(key: String) -> EventMessage {
        return EventMessage(action: BabyMonitorEvent.pushNotificationsKey.rawValue, value: key)
    }
}
