//
//  BabyMonitorCellSelectable.swift
//  Baby Monitor
//

import Foundation

protocol BabyMonitorCellSelectable {
    
    /// Selects BabyMonitor cell
    ///
    /// - Parameter cell: cell that should be selected
    func select(cell: BabyMonitorCell)
}
