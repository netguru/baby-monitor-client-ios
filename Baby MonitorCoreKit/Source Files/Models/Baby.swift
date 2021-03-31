//
//  Baby.swift
//  Baby Monitor
//

import Foundation
import UIKit

final class Baby {
    
    static let initial = Baby(name: "")
    var name: String
    var photo: UIImage?
    let id: String
    let cryingEvents: [ActivityLogEvent]

    init(id: String = UUID().uuidString, name: String, photo: UIImage? = nil, cryingEvents: [ActivityLogEvent] = []) {
        self.id = id
        self.name = name
        self.photo = photo
        self.cryingEvents = cryingEvents
    }
    
}

extension Baby: Equatable {
    static func == (lhs: Baby, rhs: Baby) -> Bool {
        return lhs.id == rhs.id
    }
}
