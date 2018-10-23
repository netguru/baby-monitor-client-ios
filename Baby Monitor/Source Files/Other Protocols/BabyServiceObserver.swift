//
//  BabyRepoObserver.swift
//  Baby Monitor
//

import Foundation

// Protocol for notifying objects about updating babies: e.g. name or photo
protocol BabyRepoObserver: AnyObject {

    func babyRepo(_ repo: BabiesRepository, didChangePhotoOf baby: Baby)
    
    func babyRepo(_ repo: BabiesRepository, didChangeNameOf baby: Baby)
}

extension BabyRepoObserver {

    func babyRepo(_ repo: BabiesRepository, didChangePhotoOf baby: Baby) {}
    
    func babyRepo(_ repo: BabiesRepository, didChangeNameOf baby: Baby) {}
}
