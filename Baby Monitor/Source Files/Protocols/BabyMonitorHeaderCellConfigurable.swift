//
//  BabyMonitorHeaderCellConfigurable.swift
//  Baby Monitor
//


import UIKit

protocol BabyMonitorHeaderCellConfigurable {
    
    func configure(headerCell: BabyMonitorCell, for section: Int)
}
