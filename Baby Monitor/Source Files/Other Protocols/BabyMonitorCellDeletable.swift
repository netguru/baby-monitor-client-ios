//
//  BabyMonitorCellDeletable.swift
//  Baby Monitor
//

import Foundation

protocol BabyMonitorCellDeletable: AnyObject {
    func canDelete(rowAt indexPath: IndexPath) -> Bool
}
