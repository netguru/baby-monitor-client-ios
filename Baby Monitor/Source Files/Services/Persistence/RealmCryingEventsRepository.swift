//
//  RealmCryingEventsRepository.swift
//  Baby Monitor
//

import RxSwift
import RxCocoa
import RealmSwift

struct CryingEvent: Equatable {
    let date: Date
    let fileName: String
    var fileURL: URL {
        return FileManager.documentsDirectoryURL.appendingPathComponent(fileName).appendingPathExtension("caf")
    }
    
    init(date: Date = Date(), fileName: String) {
        self.date = date
        self.fileName = fileName
    }
}

final class RealmCryingEventsRepository {
    
    var cryingEvents: Observable<[CryingEvent]> {
        return cryingEventsPublisher.asObservable()
    }
    private let cryingEventsPublisher = BehaviorRelay<[CryingEvent]>(value: [])
    private let realm: Realm
    private var token: NotificationToken?
    
    init(realm: Realm) {
        self.realm = realm
    }
}
