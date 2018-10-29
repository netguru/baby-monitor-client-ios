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
        return Observable.just(Section.allCases)
            .map { sections in
                return sections.map { GeneralSection(title: $0.title, items: [Lullaby(name: "Lullaby#1"), Lullaby(name: "Lullaby#2")]) }
            }
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
