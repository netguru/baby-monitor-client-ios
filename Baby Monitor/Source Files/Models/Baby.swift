//
//  Baby.swift
//  Baby Monitor
//

import Foundation

struct Baby: Equatable {

    let name: String
    let photo: UIImage?
    let id: String

    init(id: String = UUID().uuidString, name: String, photo: UIImage? = nil) {
        self.id = id
        self.name = name
        self.photo = photo
    }
}
