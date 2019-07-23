//
//  ActivityLogEvent.swift
//  Baby Monitor
//

import RxSwift
import RealmSwift

struct ActivityLogEvent: Equatable {
    let date: Date
    let mode: Mode
    
    enum Mode: String {
        case cryingEvent = "CRYING_EVENT_ACTIVITY_LOG_EVENT_KEY"
        case emptyState = "EMPTY_STATE_ACTIVITY_LOG_EVENT_KEY"
    }
    
    init(mode: Mode, date: Date = Date()) {
        self.date = date
        self.mode = mode
    }
}
