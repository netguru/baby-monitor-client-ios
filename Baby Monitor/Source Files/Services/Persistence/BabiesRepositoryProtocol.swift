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
    func save(baby: Baby) throws
    
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
    
    // Functions for observation of changes to babies
    ///
    /// - Parameter observer: class conformed to BabyRepoObserver protocol
    func addObserver(_ observer: BabyRepoObserver)
    func removeObserver(_ observer: BabyRepoObserver)
}
