//
//  SwitchBabyViewModel.swift
//  Baby Monitor
//

import Foundation

final class SwitchBabyViewModel: BabyMonitorGeneralViewModelProtocol, BabyMonitorCellSelectable {
    
    var babyService: BabyService
    
    var numberOfSections: Int {
        return 1
    }
    
    init(babyService: BabyService) {
        self.babyService = babyService
    }
    
    // MARK: - internal functions
    func configure(cell: BabyMonitorCell, for indexPath: IndexPath) {
        if indexPath.row == babyService.dataSource.babies.count {
            cell.type = .switchBaby(.addAnother)
        } else {
            let baby = babyService.dataSource.babies[indexPath.row]
            cell.update(mainText: baby.name!)
            if let babyImage = baby.photo {
                cell.update(image: babyImage)
            }
            cell.type = .switchBaby(.baby)
        }
    }
    
    func numberOfRows(for section: Int) -> Int {
        return babyService.dataSource.babies.count + 1
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
        case .activityLog, .lullaby, .settings:
            break
        }
    }
}
