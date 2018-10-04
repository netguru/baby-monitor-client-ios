//
//  SwitchBabyTableViewViewModel.swift
//  Baby Monitor
//


import Foundation

final class SwitchBabyTableViewViewModel {
    
    private var babies: [Baby] = [] //TODO: implement fetching
    
    var numberOfRows: Int {
        return babies.count + 1
    }
    
    //MARK: - internal functions
    func configure(cell: BabyMonitorCell, for indexPath: IndexPath) {
        if indexPath.row == babies.count {
            cell.type = .switchBaby(.addAnother)
        } else {
            let baby = babies[indexPath.row]
            cell.update(mainText: baby.name)
            cell.type = .switchBaby(.baby)
        }
    }
    
    func select(cell: BabyMonitorCell) {
        switch cell.type {
        case .switchBaby(let switchBabyType):
            switch switchBabyType {
            case .baby:
                //TODO: add implementation
                break
            case .addAnother:
                //TODO: add implementation
                break
            }
        case .activityLog, .lullaby:
            break
        }
    }
}
