//
//  Baby.swift
//  Baby Monitor
//

import Foundation
import UIKit

struct Baby: Equatable {
    
    static let initial = Baby(name: "Anonymous")

    let name: String
    let photo: UIImage?
    let id: String
    let cryingEvents: [ActivityLogEvent]

    init(id: String = UUID().uuidString, name: String, photo: UIImage? = nil, cryingEvents: [ActivityLogEvent] = []) {
        self.id = id
        self.name = name
        self.photo = photo
        self.cryingEvents = cryingEvents
    }
    
}
