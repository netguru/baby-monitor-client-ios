//
//  RealmBaby.swift
//  Baby Monitor
//

import RealmSwift

final class RealmBaby: Object {
    
    @objc dynamic private(set) var id: String = ""
    @objc dynamic private(set) var name: String = ""
    
    convenience init(with baby: Baby) {
        self.init()
        self.id = baby.id
        self.name = baby.name
    }
    
    func toBaby() -> Baby {
        // TODO: add handling photo, ticket: https://netguru.atlassian.net/browse/BM-91
        return Baby(id: id, name: self.name)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
