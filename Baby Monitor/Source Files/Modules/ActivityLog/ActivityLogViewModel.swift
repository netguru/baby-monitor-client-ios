//
//  ActivityLogViewModel.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import RxCocoa

final class ActivityLogViewModel: BabyMonitorGeneralViewModelProtocol, BabyMonitorHeaderCellConfigurable, BabiesViewSelectable {
    
    typealias DataType = Baby
    
    private let babyRepo: BabiesRepositoryProtocol

    init(babyRepo: BabiesRepositoryProtocol) {
        self.babyRepo = babyRepo
        self.baby = babyRepo.babyUpdateObservable
    }

    // MARK: - Coordinator callback
    private(set) var showBabies: Observable<Void>?
    private(set) var baby: Observable<Baby>
    var sections: Observable<[GeneralSection<Baby>]> {
        return baby
            .map { [GeneralSection(title: "", items: [$0])] }
    }
    
    // MARK: - Internal functions
    func attachInput(showBabiesTap: ControlEvent<Void>) {
        showBabies = showBabiesTap.asObservable()
    }
    
    func configure(cell: BabyMonitorCellProtocol, for data: Baby) {
        cell.type = .activityLog
        let baby = data
        // TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
        cell.update(secondaryText: "24 minutes ago")
        cell.update(image: baby.photo ?? UIImage())
        cell.update(mainText: "\(baby.name) was crying!")
    }

    func configure(headerCell: BabyMonitorCellProtocol, for section: Int) {
        headerCell.configureAsHeader()
        headerCell.update(mainText: "Yesterday")
    }
}
