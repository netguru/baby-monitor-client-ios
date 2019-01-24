//
//  BabyModelControllerProtocol.swift
//  Baby Monitor
//

import Foundation
import RxSwift

protocol BabyModelControllerProtocol {
    
    /// Current baby observable
    var babyUpdateObservable: Observable<Baby> { get }
    
    // Current baby
    var baby: Baby { get }
    
    /// Persists baby in repository
    ///
    /// - Parameter baby: object to persist
    /// - Parameter setCurrent: flag indicating whether baby should be set as current
    func save(baby: Baby) throws
    
    /// Removes all data from database
    func removeAllData()
    
    // Update current baby
    func updatePhoto(_ photo: UIImage)
    func updateName(_ name: String)
}
