//
//  SettingsViewModel.swift
//  Baby Monitor
//

import RxSwift
import RxCocoa

final class SettingsViewModel: BabyMonitorGeneralViewModelProtocol, BabiesViewSelectable, BabyMonitorHeaderCellConfigurable {

    private let babyRepo: BabiesRepositoryProtocol

    typealias DataType = Cell
    
    enum Section: Int, CaseIterable {
        case main = 0
        case cryingDetection = 1
        
        var title: String {
            switch self {
            case .main:
                return Localizable.Settings.main
            case .cryingDetection:
                return Localizable.Settings.cryingDetectionMethod
            }
        }
    }
    
    // MARK: - Coordinator callback
    var didSelectChangeServer: (() -> Void)?
    private(set) var showBabies: Observable<Void>?
    lazy var baby: Observable<Baby> = babyRepo.babyUpdateObservable
    
    private(set) lazy var sections: Observable<[GeneralSection<Cell>]> = {
        let mainSection = Observable.just(GeneralSection(title: Section.main.title, items: [Cell.switchToServer, Cell.changeServer]))
        let detectionSection = Observable.just(GeneralSection(title: Section.cryingDetection.title, items: [Cell.useML, Cell.useStaticCryingDetection]))
        return Observable.combineLatest(mainSection, detectionSection, resultSelector: { mainSection, detectionSection -> [GeneralSection<Cell>] in
            return [mainSection, detectionSection]
        }).concat(Observable.never())
    }()

    enum Cell: CaseIterable, Equatable {
        case switchToServer
        case changeServer
        case useML
        case useStaticCryingDetection
    }

    init(babyRepo: BabiesRepositoryProtocol) {
        self.babyRepo = babyRepo
    }

    // MARK: - Internal functions
    func attachInput(showBabiesTap: ControlEvent<Void>) {
        showBabies = showBabiesTap.asObservable()
    }
    
    func configure(cell: BabyMonitorCellProtocol, for data: Cell) {
        cell.type = .settings
        switch data {
        case Cell.switchToServer:
            //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
            cell.update(mainText: Localizable.Settings.switchToServer)
        case Cell.changeServer:
            cell.update(mainText: Localizable.Settings.changeServer)
            cell.didTap = { [weak self] in
                self?.didSelectChangeServer?()
            }
        case Cell.useML:
            cell.update(mainText: Localizable.Settings.useML)
            cell.showCheckmark(true)
        case Cell.useStaticCryingDetection:
            cell.update(mainText: Localizable.Settings.useStaticCryingDetection)
        }
    }
    
    func configure(headerCell: BabyMonitorCellProtocol, for section: Int) {
        guard let typedSection = Section(rawValue: section) else {
            return
        }
        headerCell.configureAsHeader()
        switch typedSection {
        case Section.main:
            headerCell.update(mainText: Section.main.title)
        case Section.cryingDetection:
            headerCell.update(mainText: Section.cryingDetection.title)
        }
    }
}
