//
//  LullabiesViewModel.swift
//  Baby Monitor
//

import Foundation

final class LullabiesViewModel: BabyMonitorGeneralViewModelProtocol, BabyMonitorHeaderCellConfigurable, BabiesViewSelectable {

    private let babyRepo: BabiesRepositoryProtocol

    private enum Constants {
        static let bmLibrarySection = 0
        static let yourLullabiesSection = 1
    }

    let numberOfSections = 2

    // MARK: - Coordinator callback
    var didSelectShowBabiesView: (() -> Void)?
    var didLoadBabies: ((_ baby: Baby) -> Void)?

    init(babyRepo: BabiesRepositoryProtocol) {
        self.babyRepo = babyRepo
    }

    // MARK: - Internal functions
    func configure(cell: BabyMonitorCell, for indexPath: IndexPath) {
        cell.type = .lullaby
        //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
        cell.update(mainText: "Sleep My Baby")
        cell.update(secondaryText: "2:30 mins")
    }

    func numberOfRows(for section: Int) -> Int {
        //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
        return 3
    }

    func selectShowBabies() {
        didSelectShowBabiesView?()
    }

    func configure(headerCell: BabyMonitorCell, for section: Int) {
        headerCell.configureAsHeader()
        switch section {
        case Constants.bmLibrarySection:
            headerCell.update(mainText: Localizable.Lullabies.bmLibrary)
        case Constants.yourLullabiesSection:
            headerCell.update(mainText: Localizable.Lullabies.yourLullabies)
        default:
            break
        }
    }
    
    func loadBabies() {
        guard let baby = babyRepo.fetchAllBabies().first else { return }
        didLoadBabies?(baby)
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
