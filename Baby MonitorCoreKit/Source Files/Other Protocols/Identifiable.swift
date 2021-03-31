//
//  Identifiable.swift
//  Baby Monitor
//

import Foundation

protocol Identifiable {
    
    /// Identifier for class that is it's name
    static var identifier: String { get }
}

extension Identifiable {
    
    static var identifier: String {
        return String(describing: self)
    }
}
