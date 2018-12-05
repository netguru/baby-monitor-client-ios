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
    
    static let babyIsCrying = EventMessage(action: BabyMonitorEvent.crying.rawValue, value: "")
}
