//
//  RealmBabiesRepository.swift
//  Baby Monitor
//


import Foundation
import RealmSwift

final class RealmBabiesRepository: BabiesRepository {
    
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func save(baby: Baby) {
        let realmBaby = RealmBaby(with: baby)
        try! realm.write {
            realm.add(realmBaby, update: true)
        }
    }
    
    func fetchAllBabies() -> [Baby] {
        let babies = realm.objects(RealmBaby.self)
            .map { $0.toBaby() }
        return Array(babies)
    }
}
