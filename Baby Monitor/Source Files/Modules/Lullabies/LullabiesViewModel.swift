//
//  LullabiesViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import RxCocoa

final class LullabiesViewModel: BabyMonitorGeneralViewModelProtocol, BabyMonitorHeaderCellConfigurable, BabiesViewSelectable, BabyMonitorCellDeletable {
    
    typealias DataType = Lullaby
    typealias DeletedModelType = Lullaby

    private let babyRepo: BabiesRepositoryProtocol
    private let lullabiesRepo: LullabiesRepositoryProtocol

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
        let bmLibrarySection = Observable.just(GeneralSection(title: Section.bmLibrary.title, items: BMLibraryEntry.allLullabies))
        let yourLullabiesSection = lullabiesRepo.lullabies.map { GeneralSection<Lullaby>(title: Section.yourLullabies.title, items: $0) }
        return Observable.combineLatest(bmLibrarySection, yourLullabiesSection, resultSelector: { bmLibrary, yourLullabies -> [GeneralSection<Lullaby>] in
            return [bmLibrary, yourLullabies]
        })
    }

    // MARK: - Coordinator callback
    private(set) var showBabies: Observable<Void>?
    lazy var baby: Observable<Baby> = babyRepo.babyUpdateObservable

    init(babyRepo: BabiesRepositoryProtocol, lullabiesRepo: LullabiesRepositoryProtocol) {
        self.babyRepo = babyRepo
        self.lullabiesRepo = lullabiesRepo
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
    
    // MARK: - BabyMonitorCellDeletable implementation
    func canDelete(rowAt indexPath: IndexPath) -> Bool {
        return Section(rawValue: indexPath.section) == .yourLullabies
    }
    
    // MARK: - CRUD methods
    
    /// Saves lullabies to the repository
    ///
    /// - Parameter lullabies: lullabies to save
    func save(lullabies: [Lullaby]) {
        lullabies.forEach {
            try? lullabiesRepo.save(lullaby: $0)
        }
    }
    
    func delete(model: Lullaby) {
        try? lullabiesRepo.remove(lullaby: model)
    }
}
