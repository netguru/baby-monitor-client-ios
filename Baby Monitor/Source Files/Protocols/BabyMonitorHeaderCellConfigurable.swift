//
//  BabyMonitorHeaderCellConfigurable.swift
//  Baby Monitor
//


import UIKit

protocol BabyMonitorHeaderCellConfigurable {
    
    /// Configures BabyMonitorCell to look as header
    ///
    /// - Parameters:
    ///   - headerCell: baby cell for configuring
    ///   - section: header section
    func configure(headerCell: BabyMonitorCell, for section: Int)
}
