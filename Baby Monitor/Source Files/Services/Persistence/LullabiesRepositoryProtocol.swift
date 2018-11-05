//
//  LullabiesRepositoryProtocol.swift
//  Baby Monitor
//

import RxSwift

enum LullabiesRepositoryError: Error {
    case invalidLullabyType
}

protocol LullabiesRepositoryProtocol {
    /// Observable emitting persisted lullabies
    var lullabies: Observable<[Lullaby]> { get }
    
    /// Saves lullaby to the repository
    ///
    /// - Parameter lullaby: lullaby to be persisted
    func save(lullaby: Lullaby) throws
    
    /// Removes lullaby from repository
    ///
    /// - Parameter lullaby: lullaby to be removed
    func remove(lullaby: Lullaby) throws
}
