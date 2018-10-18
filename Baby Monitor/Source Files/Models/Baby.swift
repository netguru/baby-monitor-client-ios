//
//  Baby.swift
//  Baby Monitor
//


import Foundation

final class Baby {
    
    var name: String?
    var image: UIImage?
    
    init(name: String?, photo: UIImage? = nil) {
        self.name = name
        self.image = photo
    }
}
