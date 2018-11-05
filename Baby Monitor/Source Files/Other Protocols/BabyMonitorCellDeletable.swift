//
//  BabyMonitorCellDeletable.swift
//  Baby Monitor
//

protocol BabyMonitorCellDeletable: AnyObject {
    func canDelete(rowAt indexPath: IndexPath) -> Bool
}
