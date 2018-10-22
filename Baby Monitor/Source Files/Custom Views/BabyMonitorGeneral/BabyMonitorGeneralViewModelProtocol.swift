//
//  BabyMonitorGeneralViewModelProtocol.swift
//  Baby Monitor
//

import UIKit

protocol BabyMonitorGeneralViewModelProtocol: AnyObject {

    var numberOfSections: Int { get }
    
    var didLoadBabies: ((_ baby: Baby) -> Void)? { get set }
    
    func configure(cell: BabyMonitorCell, for indexPath: IndexPath)
    func numberOfRows(for section: Int) -> Int
    
    func loadBabies()
}
