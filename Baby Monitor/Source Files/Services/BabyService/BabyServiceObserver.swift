//
//  BabyServiceObserver.swift
//  Baby Monitor
//


import Foundation

protocol BabyServiceObserver: AnyObject {

    func babyService(_ service: BabyService, didChangePhotoOf baby: Baby)
    
    func babyService(_ service: BabyService, didChangeNameOf baby: Baby)
}

extension BabyServiceObserver {

    func babyService(_ service: BabyService, didChangePhotoOf baby: Baby) {}
    
    func babyService(_ service: BabyService, didChangeNameOf baby: Baby) {}
}
