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
    
    /// Returns baby with specified id
    ///
    /// - Parameter id: id of baby to retrieve
    /// - Returns: Baby with specified id
    func fetchBaby(id: String) -> Baby?
    
    /// Returns babies with specified name
    ///
    /// - Parameter name: name of babies to retrieve
    /// - Returns: Babies with specified name
    func fetchBabies(name: String) -> [Baby]
}
