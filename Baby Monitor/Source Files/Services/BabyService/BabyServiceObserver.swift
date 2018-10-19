//
//  BabyServiceObserver.swift
//  Baby Monitor
//

import Foundation

// Protocol for notifying view controllers about updating babies: e.g. name or photo
protocol BabyServiceObserver: AnyObject {

    func babyService(_ service: BabyServiceProtocol, didChangePhotoOf baby: Baby)
    
    func babyService(_ service: BabyServiceProtocol, didChangeNameOf baby: Baby)
}

extension BabyServiceObserver {

    func babyService(_ service: BabyServiceProtocol, didChangePhotoOf baby: Baby) {}
    
    func babyService(_ service: BabyServiceProtocol, didChangeNameOf baby: Baby) {}
}
