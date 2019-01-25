//
//  DatabaseRepositoryMock.swift
//  Baby MonitorTests
//

import Foundation
import RxSwift
@testable import BabyMonitor

final class DatabaseRepositoryMock: BabyModelControllerProtocol & ActivityLogEventsRepositoryProtocol {
    
    lazy var babyUpdateObservable: Observable<Baby> = babyUpdatePublisher.asObservable()
    lazy var activityLogEventsObservable: Observable<[ActivityLogEvent]> = activityLogEventsPublisher.asObservable()
    var baby: Baby = Baby.initial {
        didSet {
            babyUpdatePublisher.onNext(baby)
        }
    }
    
    private var activityLogEvents: [ActivityLogEvent] = []
    private let activityLogEventsPublisher = BehaviorSubject<[ActivityLogEvent]>(value: [])
    private let babyUpdatePublisher = BehaviorSubject<Baby>(value: Baby.initial)
    
    init(currentBaby: Baby? = nil) {
        if let baby = currentBaby {
            self.baby = baby
        } else {
            self.baby = .initial
        }
    }
    
    func save(baby: Baby) {
        self.baby = baby
    }
    
    func removeAllData() {
        baby = .initial
    }
    
    func updatePhoto(_ photo: UIImage) {
        baby.photo = photo
        babyUpdatePublisher.onNext(baby)
    }
    
    func updateName(_ name: String) {
        baby.name = name
        babyUpdatePublisher.onNext(baby)
    }
    
    func save(activityLogEvent: ActivityLogEvent) {
        activityLogEvents.append(activityLogEvent)
        activityLogEventsPublisher.onNext(activityLogEvents)
    }
    
    func fetchAllActivityLogEvents() -> [ActivityLogEvent] {
        return activityLogEvents
    }

}
