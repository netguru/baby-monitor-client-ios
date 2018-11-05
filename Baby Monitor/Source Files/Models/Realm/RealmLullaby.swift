//
//  RealmLullaby.swift
//  Baby Monitor
//

import RealmSwift

final class RealmLullaby: Object {
    
    @objc dynamic private(set) var identifier: String = ""
    @objc dynamic private(set) var name: String = ""
    
    convenience init(with lullaby: Lullaby) {
        self.init()
        self.identifier = lullaby.identifier
        self.name = lullaby.name
    }
    
    func toLullaby() -> Lullaby {
        return Lullaby(name: name, identifier: identifier, type: .yourLullabies)
    }
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
}
