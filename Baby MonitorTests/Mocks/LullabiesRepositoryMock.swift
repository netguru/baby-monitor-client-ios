//
//  LullabiesRepositoryMock.swift
//  Baby MonitorTests
//

import RxSwift
@testable import BabyMonitor

final class LullabiesRepositoryMock: LullabiesRepositoryProtocol {
    
    private var lullabiesDict = [String: Lullaby]()
    
    var lullabies: Observable<[Lullaby]> {
        return lullabiesPublisher
    }
    private let lullabiesPublisher = BehaviorSubject<[Lullaby]>(value: [])
    
    init(currentLullabies: [Lullaby] = []) {
        currentLullabies.forEach {
            lullabiesDict[$0.identifier] = $0
        }
        lullabiesPublisher.onNext(currentLullabies)
    }
    
    func save(lullaby: Lullaby) throws {
        lullabiesDict[lullaby.identifier] = lullaby
        lullabiesPublisher.onNext(Array(lullabiesDict.values))
    }
    
    func remove(lullaby: Lullaby) throws {
        lullabiesDict.removeValue(forKey: lullaby.identifier)
    }
    
}
