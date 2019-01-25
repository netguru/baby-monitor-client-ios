//
//  RealmBabiesRepository.swift
//  Baby Monitor
//

import RealmSwift
import RxSwift
import RxCocoa

final class RealmBabiesRepository: BabyModelControllerProtocol & ActivityLogEventsRepositoryProtocol {
    
    lazy var activityLogEventsObservable: Observable<[ActivityLogEvent]> = activityLogEventsPublisher.asObservable()
    lazy var babyUpdateObservable: Observable<Baby> = babyPublisher.asObservable()
    var baby: Baby {
        return babyPublisher.value
    }
    
    private var babyPublisher = Variable<Baby>(Baby.initial)
    private let activityLogEventsPublisher = Variable<[ActivityLogEvent]>([])
    private let realm: Realm
    private var currentBabyToken: NotificationToken?
    
    init(realm: Realm) {
        self.realm = realm
        setup()
    }
    
    func save(activityLogEvent: ActivityLogEvent) {
        let realmActivityLogEvent = RealmActivityLogEvent(with: activityLogEvent)
        try! realm.write {
            realm.create(RealmActivityLogEvent.self, value: realmActivityLogEvent, update: false)
            activityLogEventsPublisher.value.append(activityLogEvent)
        }
    }
    
    func fetchAllActivityLogEvents() -> [ActivityLogEvent] {
        let activityLogEvents = realm.objects(RealmActivityLogEvent.self)
            .map { $0.toActivityLogEvent() }
        return Array(activityLogEvents)
    }
    
    func removeAllData() {
        try! realm.write {
            realm.deleteAll()
            babyPublisher.value = Baby.initial
            activityLogEventsPublisher.value = []
        }
    }
    
    func updatePhoto(_ photo: UIImage) {
        try! realm.write {
            guard let photoData = photo.jpegData(compressionQuality: 1) else { return }
            _ = realm.create(RealmBaby.self, value: ["id": baby.id, "photoData": photoData], update: true)
                .toBaby()
            babyPublisher.value.photo = photo
            let currentBaby = self.baby
            self.babyPublisher.value = currentBaby
        }
        
    }
    
    func updateName(_ name: String) {
        try! realm.write {
            _ = realm.create(RealmBaby.self, value: ["id": baby.id, "name": name], update: true)
                .toBaby()
            babyPublisher.value.name = name
            let currentBaby = self.baby
            self.babyPublisher.value = currentBaby
        }
    }
    
    private func setup() {
        try! realm.write {
            if let realmBaby = realm.objects(RealmBaby.self).first {
                babyPublisher.value = realmBaby.toBaby()
            } else {
                realm.create(RealmBaby.self, value: ["id": baby.id, "name": baby.name], update: false)
            }
            activityLogEventsPublisher.value = fetchAllActivityLogEvents()
        }
    }
}
