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
    
    /// Removes all data from database
    func removeAllData()
    
    // Update current baby
    func updatePhoto(_ photo: UIImage)
    func updateName(_ name: String)
}
