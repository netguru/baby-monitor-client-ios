//
//  SwitchBabyViewModel.swift
//  Baby Monitor
//


import Foundation

final class SwitchBabyViewModel: BabyMonitorGeneralViewModelProtocol, BabyMonitorCellSelectable {
    
    var numberOfSections: Int {
        return 1
    }
    
    private var babies: [Baby] = [Baby(name: "Franuś")] //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
    
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
    
    func numberOfRows(for section: Int) -> Int {
        return babies.count + 1
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
        case .activityLog, .lullaby, .setting:
            break
        }
    }
}
