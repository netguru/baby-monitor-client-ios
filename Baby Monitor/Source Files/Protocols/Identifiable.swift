//
//  Identifiable.swift
//  CiLabs
//

import Foundation

protocol Identifiable {
    
    static var identifier: String { get }
}

extension Identifiable {
    
    static var identifier: String {
        return String(describing: self)
    }
}
