//
//  LullabiesViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import RxCocoa

final class LullabiesViewModel: BabyMonitorGeneralViewModelProtocol, BabyMonitorHeaderCellConfigurable, BabiesViewSelectable {
    
    typealias DataType = Lullaby

    private let babyRepo: BabiesRepositoryProtocol

    enum Section: Int, CaseIterable {
        case bmLibrary = 0
        case yourLullabies = 1
        
        var title: String {
            switch self {
            case .bmLibrary:
                return Localizable.Lullabies.bmLibrary
            case .yourLullabies:
                return Localizable.Lullabies.yourLullabies
            }
        }
    }

    var sections: Observable<[GeneralSection<Lullaby>]> {
        let bmLibrarySection = GeneralSection(title: Section.bmLibrary.title, items: BMLibraryEntry.allLullabies)
        let yourLullabiesSection = GeneralSection<Lullaby>(title: Section.yourLullabies.title, items: [])
        return Observable.just([bmLibrarySection, yourLullabiesSection])
            .concat(Observable.never())
    }

    // MARK: - Coordinator callback
    private(set) var showBabies: Observable<Void>?
    lazy var baby: Observable<Baby> = babyRepo.babyUpdateObservable

    init(babyRepo: BabiesRepositoryProtocol) {
        self.babyRepo = babyRepo
    }

    // MARK: - Internal functions
    func attachInput(showBabiesTap: ControlEvent<Void>) {
        self.showBabies = showBabiesTap.asObservable()
    }
    
    func configure(cell: BabyMonitorCellProtocol, for data: Lullaby) {
        cell.type = .lullaby
        let lullaby = data
        //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
        cell.update(mainText: lullaby.name)
        cell.update(secondaryText: lullaby.name)
    }

    func configure(headerCell: BabyMonitorCellProtocol, for section: Int) {
        guard let typedSection = Section(rawValue: section) else {
            return
        }
        headerCell.configureAsHeader()
        switch typedSection {
        case Section.bmLibrary:
            headerCell.update(mainText: Localizable.Lullabies.bmLibrary)
        case Section.yourLullabies:
            headerCell.update(mainText: Localizable.Lullabies.yourLullabies)
        }
    }
}
