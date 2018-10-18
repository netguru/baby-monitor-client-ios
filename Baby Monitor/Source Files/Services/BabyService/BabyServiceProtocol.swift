//
//  BabyServiceProtocol.swift
//  Baby Monitor
//


import Foundation

protocol BabyServiceDataSource: class {
    
    /// Data to be used
    var babies: [Baby] { get set }
}

/// Protocol that should be conformed by every new class of baby service
protocol BabyServiceProtocol: class {
    
    var dataSource: BabyServiceDataSource { get set }
    
    func setCurrent(baby: Baby)
    func setPhoto(_ photo: UIImage)
    func setName(_ name: String)
}
