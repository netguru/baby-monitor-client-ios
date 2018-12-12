//
//  RealmLullabiesRepository.swift
//  Baby Monitor
//

import RxSwift
import RxCocoa
import RealmSwift

final class RealmLullabiesRepository: LullabiesRepositoryProtocol {
    
    var lullabies: Observable<[Lullaby]> {
        if token == nil {
            setupNotifications()
        }
        return lullabiesPublisher.asObservable()
    }
    private let lullabiesPublisher = BehaviorRelay<[Lullaby]>(value: [])
    private let realm: Realm
    private var token: NotificationToken?
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func save(lullaby: Lullaby) throws {
        guard lullaby.type != .bmLibrary else {
            throw LullabiesRepositoryError.invalidLullabyType
        }
        let realmLullaby = RealmLullaby(with: lullaby)
        try! realm.write {
            realm.add(realmLullaby, update: true)
        }
    }
    
    func remove(lullaby: Lullaby) throws {
        guard let realmLullaby = realm.object(ofType: RealmLullaby.self, forPrimaryKey: lullaby.identifier) else {
            return
        }
        try! realm.write {
            realm.delete(realmLullaby)
        }
    }
    
    private func setupNotifications() {
        let lullabies = realm.objects(RealmLullaby.self)
        lullabiesPublisher.accept(lullabies.map { $0.toLullaby() })
        token = lullabies.observe { [unowned self] changes in
            switch changes {
            case .update(let lullabies, _, _, _):
                self.lullabiesPublisher.accept(lullabies.map { $0.toLullaby() })
            default:
                break
            }
        }
    }
    
}
