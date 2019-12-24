//
//  EventMessage.swift
//  Baby Monitor
//

import Foundation

enum BabyMonitorEvent: String {
    case pushNotificationsKey = "PUSH_NOTIFICATIONS_KEY"
    case resetKey = "RESET_KEY"
    case pairingCodeKey = "pairingCode"
    case pairingCodeResponseKey = "pairingResponse"
}

struct EventMessage: Codable {
    let action: String
    var value: String?
    var boolValue: Bool?

    static func initWithPushNotificationsKey(key: String) -> EventMessage {
        return EventMessage(action: BabyMonitorEvent.pushNotificationsKey.rawValue, value: key)
    }
    
    static func initWithResetKey() -> EventMessage {
        return EventMessage(action: BabyMonitorEvent.resetKey.rawValue, value: nil)
    }

    static func initWithPairingCodeResponseKey(value: Bool) -> EventMessage {
        return EventMessage(action: BabyMonitorEvent.pairingCodeResponseKey.rawValue, boolValue: value)
    }
}
