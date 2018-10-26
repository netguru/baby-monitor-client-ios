//
//  BabyRepoObserver.swift
//  Baby Monitor
//

import Foundation

// Protocol for notifying objects about updating babies: e.g. name or photo
protocol BabyRepoObserver: AnyObject {

    func babyRepo(_ repo: BabiesRepositoryProtocol, didChangePhotoOf baby: Baby)
    
    func babyRepo(_ repo: BabiesRepositoryProtocol, didChangeNameOf baby: Baby)
}

extension BabyRepoObserver {

    func babyRepo(_ repo: BabiesRepositoryProtocol, didChangePhotoOf baby: Baby) {}
    
    func babyRepo(_ repo: BabiesRepositoryProtocol, didChangeNameOf baby: Baby) {}
}
