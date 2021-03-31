//
//  RealmActivityLogEvent.swift
//  Baby Monitor
//

import RealmSwift

final class RealmActivityLogEvent: Object {
    
    @objc dynamic private(set) var date: Date = Date()
    @objc dynamic private(set) var modeKey: String = ""
    
    convenience init(with activityLogEvent: ActivityLogEvent) {
        self.init()
        self.date = activityLogEvent.date
        self.modeKey = activityLogEvent.mode.rawValue
    }
    
    func toActivityLogEvent() -> ActivityLogEvent {
        let mode = ActivityLogEvent.Mode(rawValue: modeKey) ?? .cryingEvent
        return ActivityLogEvent(mode: mode, date: date)
    }
}
