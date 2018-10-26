//
//  RealmBaby.swift
//  Baby Monitor
//

import RealmSwift

final class RealmBaby: Object {
    
    @objc dynamic private(set) var id: String = ""
    @objc dynamic private(set) var name: String = ""
    @objc dynamic private(set) var photoData: Data?
    
    convenience init(with baby: Baby) {
        self.init()
        self.id = baby.id
        self.name = baby.name
        self.photoData = baby.photo?.jpegData(compressionQuality: 1)
    }
    
    func toBaby() -> Baby {
        if let photoData = photoData {
            return Baby(id: id, name: name, photo: UIImage(data: photoData))
        } else {
            return Baby(id: id, name: name)
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
