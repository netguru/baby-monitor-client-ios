//
//  Baby.swift
//  Baby Monitor
//


import Foundation

final class Baby: Equatable {
    
    let name: String
    let id: String
    
    init(id: String = UUID.init().uuidString, name: String) {
        self.id = id
        self.name = name
    }
    
    static func == (lhs: Baby, rhs: Baby) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
