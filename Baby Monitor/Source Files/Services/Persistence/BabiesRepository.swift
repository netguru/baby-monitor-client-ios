//
//  BabiesRepository.swift
//  Baby Monitor
//


import Foundation

protocol BabiesRepository {
    
    /// Persists baby in repository
    ///
    /// - Parameter baby: object to persist
    func save(baby: Baby)
    
    /// Returns all persisted babies
    ///
    /// - Returns: Babies currently persisted in repository
    func fetchAllBabies() -> [Baby]
}
