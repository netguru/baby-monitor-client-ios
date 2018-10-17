//
//  RealmBaby.swift
//  Baby Monitor
//


import Foundation
import RealmSwift

final class RealmBaby: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    
    convenience init(with baby: Baby) {
        self.init()
        self.id = baby.id
        self.name = baby.name
    }
    
    func toBaby() -> Baby {
        return Baby(id: id,
                    name: self.name)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
