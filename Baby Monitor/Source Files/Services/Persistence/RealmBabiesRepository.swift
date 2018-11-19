//
//  RealmBabiesRepository.swift
//  Baby Monitor
//

import RealmSwift
import RxSwift
import RxCocoa

final class RealmBabiesRepository: BabiesRepositoryProtocol & CryingEventsRepositoryProtocol {
    
    enum UpdateType {
        case name(Baby)
        case image(Baby)
    }
    
    lazy var babyUpdateObservable = babyPublisher
        .filter { $0 != nil }
        .map { $0! }
    
    var currentBabyId: String? {
        didSet {
            guard let currentBabyId = currentBabyId else {
                babyPublisher.accept(nil)
                return
            }
            let realmBaby = realm.object(ofType: RealmBaby.self, forPrimaryKey: currentBabyId)
            if let baby = realmBaby?.toBaby() {
                self.babyPublisher.accept(baby)
            }
            currentBabyToken = realmBaby?.observe({ _ in
                guard let baby = self.realm.object(ofType: RealmBaby.self, forPrimaryKey: currentBabyId)?.toBaby() else {
                    return
                }
                self.babyPublisher.accept(baby)
            })
        }
    }
    
    private var babyPublisher = BehaviorRelay<Baby?>(value: nil)
    private let realm: Realm
    private var currentBabyToken: NotificationToken?
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func save(baby: Baby) throws {
        let realmBaby = RealmBaby(with: baby)
        try! realm.write {
            realm.add(realmBaby, update: true)
        }
    }
    
    func setCurrentBaby(baby: Baby) {
        currentBabyId = baby.id
    }
    
    func getCurrentBaby() -> Baby {
        guard let currentBabyId = currentBabyId,
            let realmBaby = realm.object(ofType: RealmBaby.self, forPrimaryKey: currentBabyId) else {
                let baby = Baby(name: "Anonymous")
                try! save(baby: baby)
                return baby
                
        }
        return realmBaby.toBaby()
    }
    
    func save(cryingEvent: CryingEvent) {
        let realmCryingEvent = RealmCryingEvent(with: cryingEvent)
        guard let currentBabyId = currentBabyId,
            let realmBaby = realm.object(ofType: RealmBaby.self, forPrimaryKey: currentBabyId) else {
                return
        }
        try! realm.write {
            realmBaby.cryingEvents.append(realmCryingEvent)
        }
    }
    
    func fetchAllCryingEvents() -> [CryingEvent] {
        let cryingEvents = realm.objects(RealmCryingEvent.self)
            .map { $0.toCryingEvent() }
        return Array(cryingEvents)
    }
    
    func remove(cryingEvent: CryingEvent) {
        let allCryingEvents = realm.objects(RealmCryingEvent.self)
        guard let foundedEvent = allCryingEvents.first(where: { $0.fileName == cryingEvent.fileName
        }) else {
            return
        }
        try! realm.write {
            realm.delete(foundedEvent)
            try? FileManager.default.removeItem(at: FileManager.documentsDirectoryURL.appendingPathComponent(foundedEvent.fileName).appendingPathExtension("caf"))
        }
    }
    
    func fetchAllBabies() -> [Baby] {
        let babies = realm.objects(RealmBaby.self)
            .map { $0.toBaby() }
        return Array(babies)
    }
    
    func removeAllBabies() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func fetchBaby(id: String) -> Baby? {
        return realm.object(ofType: RealmBaby.self, forPrimaryKey: id)?
            .toBaby()
    }
    
    func fetchBabies(name: String) -> [Baby] {
        let babies = realm.objects(RealmBaby.self)
            .filter { $0.name == name }
            .map { $0.toBaby() }
        return Array(babies)
    }
    
    func setPhoto(_ photo: UIImage, id: String) {
        try! realm.write {
            guard let photoData = photo.jpegData(compressionQuality: 1) else { return }
            _ = realm.create(RealmBaby.self, value: ["id": id, "photoData": photoData], update: true)
                .toBaby()
        }
    }
    
    func setName(_ name: String, id: String) {
        try! realm.write {
            _ = realm.create(RealmBaby.self, value: ["id": id, "name": name], update: true)
                .toBaby()
        }
    }
    
    func setCurrentPhoto(_ photo: UIImage) {
        guard let currentId = currentBabyId else {
            return
        }
        setPhoto(photo, id: currentId)
    }
    
    func setCurrentName(_ name: String) {
        guard let currentId = currentBabyId else {
            return
        }
        setName(name, id: currentId)
    }
}
