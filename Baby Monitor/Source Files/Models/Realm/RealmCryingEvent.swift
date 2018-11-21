//
//  RealmCryingEvent.swift
//  Baby Monitor
//

import RealmSwift

final class RealmCryingEvent: Object {
    
    @objc dynamic private(set) var date: Date = Date()
    @objc dynamic private(set) var fileName: String = ""
    
    convenience init(with cryingEvent: CryingEvent) {
        self.init()
        self.date = cryingEvent.date
        self.fileName = cryingEvent.fileName
    }
    
    func toCryingEvent() -> CryingEvent {
        return CryingEvent(date: date, fileName: fileName)
    }
}
