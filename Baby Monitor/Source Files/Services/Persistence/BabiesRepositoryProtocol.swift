//
//  BabiesRepositoryProtocol.swift
//  Baby Monitor
//

import Foundation
import RxSwift

protocol BabiesRepositoryProtocol {
    
    /// Current baby observable
    var babyUpdateObservable: Observable<Baby> { get }
    
    /// Persists baby in repository
    ///
    /// - Parameter baby: object to persist
    /// - Parameter setCurrent: flag indicating whether baby should be set as current
    func save(baby: Baby) throws
    
    /// Sets baby as current one
    ///
    /// - Parameter baby: object to set as current
    func setCurrentBaby(baby: Baby)
    
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
    
    /// Removes all persisted babies
    func removeAllBabies()
    
    // Update current baby
    func setPhoto(_ photo: UIImage, id: String)
    func setName(_ name: String, id: String)
    
    /// Change current baby photo to provided one
    ///
    /// - Parameter photo: Photo to set
    func setCurrentPhoto(_ photo: UIImage)
    
    
    /// Change current baby name to provided one
    ///
    /// - Parameter name: Name to set
    func setCurrentName(_ name: String)
}
