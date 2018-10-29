//
//  SwitchBabyViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import RxCocoa

final class SwitchBabyViewModel: BabyMonitorGeneralViewModelProtocol, BabyMonitorCellSelectable {
    
    typealias DataType = Cell
    
    private let babyRepo: BabiesRepositoryProtocol
    
    enum Cell: Equatable {
        case baby(Baby)
        case addAnother
    }
    
    private(set) var showBabies: Observable<Void>?
    lazy var baby: Observable<Baby> = babyRepo.babyUpdateObservable
    lazy private(set) var sections: Observable<[GeneralSection]> = {
        return baby.map { [$0] }
            .map { babies in
                babies.map { Cell.baby($0) }
            }
            .map { $0 + [Cell.addAnother] }
            .map { cells in
                [GeneralSection(title: "", items: cells)]
            }
    }()

    init(babyRepo: BabiesRepositoryProtocol) {
        self.babyRepo = babyRepo
    }
    
    // MARK: - internal functions
    func configure(cell: BabyMonitorCellProtocol, for data: Cell) {
        let cellData = data
        switch cellData {
        case .baby(let baby):
            cell.update(mainText: baby.name)
            if let babyImage = baby.photo {
                cell.update(image: babyImage)
            }
            cell.type = .switchBaby(.baby)
        case .addAnother:
            cell.type = .switchBaby(.addAnother)
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
        case .activityLog, .lullaby, .settings:
            break
        }
    }
}
