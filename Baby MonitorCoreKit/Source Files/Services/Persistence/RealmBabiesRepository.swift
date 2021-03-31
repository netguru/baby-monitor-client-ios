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
    
    private var babyPublisher = BehaviorRelay<Baby>(value: Baby.initial)
    private let activityLogEventsPublisher = BehaviorRelay<[ActivityLogEvent]>(value: [])
    private let realm: Realm
    private var currentBabyToken: NotificationToken?
    
    init(realm: Realm) {
        self.realm = realm
        setup()
    }
    
    func save(activityLogEvent: ActivityLogEvent, completion: @escaping (Result<()>) -> Void) {
        DispatchQueue.main.async {
            let realmActivityLogEvent = RealmActivityLogEvent(with: activityLogEvent)
            do {
                try self.realm.write {
                    self.realm.create(RealmActivityLogEvent.self, value: realmActivityLogEvent, update: .error)
                    self.activityLogEventsPublisher.accept(self.activityLogEventsPublisher.value + [activityLogEvent])
                    completion(.success(()))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchAllActivityLogEvents() -> [ActivityLogEvent] {
        let activityLogEvents = realm.objects(RealmActivityLogEvent.self)
            .map { $0.toActivityLogEvent() }
        return Array(activityLogEvents)
    }
    
    func removeAllData() {
        DispatchQueue.main.async {
            try! self.realm.write {
                self.realm.deleteAll()
                self.babyPublisher.accept(Baby.initial)
                self.activityLogEventsPublisher.accept([])
            }
        }
    }
    
    func updatePhoto(_ photo: UIImage) {
        DispatchQueue.main.async {
            try! self.realm.write {
                guard let photoData = photo.jpegData(compressionQuality: 1) else { return }
                _ = self.realm.create(RealmBaby.self, value: ["id": self.baby.id, "photoData": photoData], update: .modified)
                    .toBaby()
                self.babyPublisher.value.photo = photo
                let currentBaby = self.baby
                self.babyPublisher.accept(currentBaby)
            }
        }
    }
    
    func updateName(_ name: String) {
        DispatchQueue.main.async {
            try! self.realm.write {
                _ = self.realm.create(RealmBaby.self, value: ["id": self.baby.id, "name": name], update: .modified)
                    .toBaby()
                self.babyPublisher.value.name = name
                let currentBaby = self.baby
                self.babyPublisher.accept(currentBaby)
            }
        }
    }
    
    private func setup() {
        DispatchQueue.main.async {
            try! self.realm.write {
                if let realmBaby = self.realm.objects(RealmBaby.self).first {
                    self.babyPublisher.accept(realmBaby.toBaby())
                } else {
                    self.realm.create(RealmBaby.self, value: ["id": self.baby.id, "name": self.baby.name], update: .error)
                }
                self.activityLogEventsPublisher.accept(self.fetchAllActivityLogEvents())
            }
        }
    }
}
