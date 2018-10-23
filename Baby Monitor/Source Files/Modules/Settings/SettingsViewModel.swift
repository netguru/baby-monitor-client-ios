//
//  SettingsViewModel.swift
//  Baby Monitor
//

import Foundation

final class SettingsViewModel: BabyMonitorGeneralViewModelProtocol, BabiesViewSelectable {

    private let babyRepo: BabiesRepository

    let numberOfSections = 1

    // MARK: - Coordinator callback
    var didSelectShowBabiesView: (() -> Void)?
    var didLoadBabies: ((_ baby: Baby) -> Void)?

    private enum Constants {
        static let switchToServerCell = 0
    }

    init(babyRepo: BabiesRepository) {
        self.babyRepo = babyRepo
    }

    // MARK: - Internal functions
    func configure(cell: BabyMonitorCell, for indexPath: IndexPath) {
        cell.type = .settings
        switch indexPath.row {
        case Constants.switchToServerCell:
            //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
            cell.update(mainText: Localizable.Settings.switchToServer)
        default:
            break
        }
    }

    func numberOfRows(for section: Int) -> Int {
        return 1
    }

    func selectShowBabies() {
        didSelectShowBabiesView?()
    }
    
    func loadBabies() {
        guard let baby = babyRepo.fetchAllBabies().first else { return }
        didLoadBabies?(baby)
    }
    
    /// Sets observer to react to changes in the baby.
    ///
    /// - Parameter controller: A controller conformed to BabyRepoObserver.
    func addObserver(_ observer: BabyRepoObserver) {
        babyRepo.addObserver(observer)
    }
    
    /// Removes observer to react to changes in the baby.
    ///
    /// - Parameter controller: A controller conformed to BabyRepoObserver.
    func removeObserver(_ observer: BabyRepoObserver) {
        babyRepo.removeObserver(observer)
    }
}
