//
//  CryingEvent.swift
//  Baby Monitor
//

import RxSwift
import RealmSwift

struct CryingEvent: Equatable {
    let date: Date
    let fileName: String
    
    init(date: Date = Date(), fileName: String) {
        self.date = date
        self.fileName = fileName
    }
}
