//
//  SwitchBabyViewModel.swift
//  Baby Monitor
//

import Foundation

final class SwitchBabyViewModel: BabyMonitorGeneralViewModelProtocol, BabyMonitorCellSelectable {
    
    private let babyRepo: BabiesRepositoryProtocol
    
    var numberOfSections: Int {
        return 1
    }
    
    var didLoadBabies: ((_ baby: Baby) -> Void)?
    
    init(babyRepo: BabiesRepositoryProtocol) {
        self.babyRepo = babyRepo
    }
    
    // MARK: - internal functions
    func configure(cell: BabyMonitorCell, for indexPath: IndexPath) {
        if indexPath.row == babyRepo.fetchAllBabies().count {
            cell.type = .switchBaby(.addAnother)
        } else {
            let baby = babyRepo.fetchAllBabies()[indexPath.row]
            cell.update(mainText: baby.name)
            if let babyImage = baby.photo {
                cell.update(image: babyImage)
            }
            cell.type = .switchBaby(.baby)
        }
    }
    
    func numberOfRows(for section: Int) -> Int {
        return babyRepo.fetchAllBabies().count + 1
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
    
    func loadBabies() {
        guard let baby = babyRepo.fetchAllBabies().first else { return }
        didLoadBabies?(baby)
    }
}
