//
//  SettingsViewModel.swift
//  Baby Monitor
//

import RxSwift
import RxCocoa

final class SettingsViewModel: BabyMonitorGeneralViewModelProtocol, BabiesViewSelectable {

    private let babyRepo: BabiesRepository

    typealias DataType = Cell
    
    // MARK: - Coordinator callback
    var didSelectChangeServer: (() -> Void)?
    private(set) var showBabies: Observable<Void>?
    var baby: Observable<Baby> {
        return babyPublisher.asObservable()
    }
    private let babyPublisher = PublishRelay<Baby>()
    
    private(set) lazy var sections: Observable<[GeneralSection]> = {
        return Observable.just(Cell.allCases)
            .map { cells in
                return [GeneralSection(title: "", items: cells)]
            }
    }()

    enum Cell: CaseIterable {
        case switchToServer
        case changeServer
    }

    init(babyRepo: BabiesRepository) {
        self.babyRepo = babyRepo
    }

    // MARK: - Internal functions
    func attachInput(showBabiesTap: ControlEvent<Void>) {
        showBabies = showBabiesTap.asObservable()
    }
    
    func configure(cell: BabyMonitorCell, for data: Cell) {
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
    
    func loadBabies() {
        guard let baby = babyRepo.fetchAllBabies().first else { return }
        babyPublisher.accept(baby)
    }
    
    /// Sets observer to react to changes in the baby.
    ///
    /// - Parameter observer: An object conformed to BabyRepoObserver protocol.
    func addObserver(_ observer: BabyRepoObserver) {
        babyRepo.addObserver(observer)
    }
    
    /// Removes observer to react to changes in the baby.
    ///
    /// - Parameter observer: An object conformed to BabyRepoObserver protocol.
    func removeObserver(_ observer: BabyRepoObserver) {
        babyRepo.removeObserver(observer)
    }
}
