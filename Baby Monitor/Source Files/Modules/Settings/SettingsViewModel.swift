//
//  SettingsViewModel.swift
//  Baby Monitor
//

import RxSwift
import RxCocoa

final class SettingsViewModel: BabyMonitorGeneralViewModelProtocol, BabiesViewSelectable {

    private let babyRepo: BabiesRepositoryProtocol

    typealias DataType = Cell
    
    // MARK: - Coordinator callback
    var didSelectChangeServer: (() -> Void)?
    private(set) var showBabies: Observable<Void>?
    lazy var baby: Observable<Baby> = babyRepo.babyUpdateObservable
    
    private(set) lazy var sections: Observable<[GeneralSection]> = {
        return Observable.just(Cell.allCases)
            .map { cells in
                return [GeneralSection(title: "", items: cells)]
            }
            .concat(Observable.never())
    }()

    enum Cell: CaseIterable, Equatable {
        case switchToServer
        case changeServer
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
        }
    }
}
