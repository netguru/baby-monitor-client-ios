//
//  CryingEventsRepositoryMock.swift
//  Baby MonitorTests
//

import Foundation
import RxSwift
@testable import BabyMonitor

final class CryingEventsRepositoryMock: CryingEventsRepositoryProtocol {
    private var cryingEvents: [CryingEvent] = []
    
    func save(cryingEvent: CryingEvent) {
        cryingEvents.append(cryingEvent)
    }
    
    func fetchAllCryingEvents() -> [CryingEvent] {
        return cryingEvents
    }
    
    func remove(cryingEvent: CryingEvent) {
        cryingEvents = cryingEvents.filter({
            $0.fileName != cryingEvent.fileName
        })
    }
}
