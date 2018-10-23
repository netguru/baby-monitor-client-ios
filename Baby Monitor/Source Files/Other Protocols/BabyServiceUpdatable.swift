//
//  BabyServiceUpdatable.swift
//  Baby Monitor
//

import Foundation

// Protocol for updating views in controllers to react to baby's updates
protocol BabyServiceUpdatable: AnyObject {
    
    func updateViews(with baby: Baby)
    func updateName(_ name: String)
    func updatePhoto(_ photo: UIImage?)
}

extension BabyServiceUpdatable {
    
    func updatePhoto(_ photo: UIImage?) {}
    func updateName(_ name: String) {}
}
