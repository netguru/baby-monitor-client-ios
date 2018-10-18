//
//  Baby.swift
//  Baby Monitor
//

import Foundation

struct Baby: Equatable {

    var name: String?
    var image: UIImage?
    let id: String

    init(id: String = UUID().uuidString, name: String, photo: UIImage? = nil) {
        self.id = id
        self.name = name
        self.image = photo
    }
}
