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
}
