//
//  Baby.swift
//  Baby Monitor
//

import Foundation

struct Baby: Equatable {
    
    let name: String
    let id: String
    
    init(id: String = UUID().uuidString, name: String) {
        self.id = id
        self.name = name
    }
}
